package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strings"
)

func main() {
	// get file from terminal
	inputFile := os.Args[1]
	searchString := os.Args[2]

	// read the whole content of file and pass it to file variable, in case of error pass it to err variable
	file, err := ioutil.ReadFile(inputFile)
	if err != nil {
		fmt.Printf("Could not read the file due to this %s error \n", err)
	}
	// convert the file binary into a string using string
	fileContent := string(file)
	// print file content
	// fmt.Println(fileContent)
	v := strings.Split(fileContent, "Host ")
	j := 0
	for range v {
		// fmt.Printf("##j: %d\n", j)
		// fmt.Println(v[j])
		hostInfo := strings.TrimSpace(v[j])
		// fmt.Printf("hostInfo: '%s'\n", hostInfo)
		if len(hostInfo) != 0 {
			hostParts := strings.Split(hostInfo, "\n")
			// fmt.Println(hostParts)
			hostAlias := strings.TrimSpace(hostParts[0])
			if hostAlias == searchString {
				fmt.Printf("Host %s\n", hostInfo)
			}
		}
		j++
	}
}
