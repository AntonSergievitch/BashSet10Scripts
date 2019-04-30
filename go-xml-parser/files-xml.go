package main

import (
	"archive/zip"
//	"compress/flate"
	"go-xmldom"
//	"crypto/md5"
	"fmt"
	xj "github.com/basgys/goxml2json"
	gj "github.com/thedevsaddam/gojsonq"
	"log"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

var ConfigRoot *gj.JSONQ

func main() {

	ConfigfilePath :="config.json"
	ConfigRoot = gj.New().File(ConfigfilePath)
	XMLPath, errs :=ConfigRoot.Find("xml").(string)
	if errs != true {
		log.Fatal("Can't read from config param \"xml\"")
	}
	//fmt.Println(XMLPath)
	resultpath, errs :=ConfigRoot.Reset().Find("result").(string)
	if errs != true {
		log.Fatal("Can't read from config param \"result\"")
	}
	//fmt.Println(resultpath)

	newZipFile, err := os.Create(resultpath)
	if err != nil {
		log.Fatal(err)
	}
	defer newZipFile.Close()

	zipWriter := zip.NewWriter(newZipFile)

	libRegEx, e := regexp.Compile("^.+\\.(xml)$")
	if e != nil {
		log.Fatal(e)
	}

	e = filepath.Walk(XMLPath, func(path string, info os.FileInfo, err error) error {
		if err == nil && libRegEx.MatchString(info.Name()) {
			//fmt.Println(path)
			f, err :=zipWriter.Create(strings.TrimPrefix(path,XMLPath))
			if err != nil {
				log.Fatal(err)
			}
			_, err = f.Write([]byte(visitXML(path)))
			if err != nil {
				log.Fatal(err)
			}
		}
		return nil
	})

	err = zipWriter.Close()
	if err != nil {
		log.Fatal(err)
	}

	if e != nil {
		log.Fatal(e)
	}
}

func visitXML(path string) string{
	xml, err := xmldom.ParseFile(path)
	if err != nil {
		fmt.Println("Can't read file:", path,err)
		//panic(err)
		return ""
	}

	config_query:=ConfigRoot.Reset().From("RemoveNode")
	for i:=0; i < config_query.Count(); i++ {
		config_data:=config_query.Nth(i+1).(map[string]interface{})
		xml.Root.QueryEachDefer(config_data["XQuery"].(string), func(x int, n *xmldom.Node) {
			xml.Root.RemoveChild(n)
		})
	}
	config_query=ConfigRoot.Reset().From("ReplaceInAttrWhereOtherAttr")
	for i:=0; i < config_query.Count(); i++ {
		config_data := config_query.Nth(i + 1).(map[string]interface{})
		xml.Root.QueryEach(config_data["SearchNode"].(string), func(x int, n *xmldom.Node) {
			n.SetAttributeValue(config_data["ReplaceAttr"].(string), "$"+n.GetAttributeContains(config_data["GetValueFrom"].(string)).Value)
		})
	}

	config_query=ConfigRoot.Reset().From("ReplaceInValue")
	for i:=0; i < config_query.Count(); i++ {
		config_data := config_query.Nth(i + 1).(map[string]interface{})
		xml.Root.QueryEach("//*contains(text(),'"+config_data["OldSubStr"].(string)+"')", func(x int, n *xmldom.Node) {
			n.Text=(strings.Replace(n.Text,config_data["OldSubStr"].(string),config_data["NewSubStr"].(string),-1))})
		xml.Root.QueryEach("*[contains(@*,'"+config_data["OldSubStr"].(string)+"')]", func(x int, n *xmldom.Node) {
			AttrName:= n.GetAttributeNameWhereValueContains( config_data["OldSubStr"].(string) )
			n.SetAttributeValue(AttrName,strings.Replace(n.GetAttributeValue( AttrName ),config_data["OldSubStr"].(string),config_data["NewSubStr"].(string),-1))})
	}
/*	xml.Root.QueryEach("*[contains(@key,'cash')]", func(x int, n *xmldom.Node) {
		n.SetAttributeValue("value", "$"+n.GetAttributeContains("key").Value)
	})
*/	xml.Root.SortXML("asc")
	//	fmt.Printf(xml.XMLPretty(),"\n---\n\n")
	json, err := xj.Convert(strings.NewReader(xml.XML()), xj.WithTypeConverter(xj.Float))
	if err != nil {
		panic("That's embarrassing...")
	}

	//fmt.Printf("%s%s%x\n",path,json.String(),md5.Sum([]byte(json.String())))
	return json.String()
}

