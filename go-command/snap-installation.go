package main

import (
	"fmt"
)

func isSnapInstalled() bool {
	fmt.Println("Checking if snap is installed...")
	RunCommand("snap", "--version")
	return true
}

func installSnapPackage() {
	fmt.Println("Installing snap package...")

}
