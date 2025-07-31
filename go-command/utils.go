package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"
)

func CheckError(err error, message string) {
	if err != nil {
		log.Fatalf("%s: %v", message, err)
	}
}
func RunCommand(name string, args ...string) {
	fmt.Printf("Running command: %s %s\n", name, strings.Join(args, " "))
	cmd := exec.Command(name, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	CheckError(cmd.Run(), "lỗi khi chạy lệnh"+name+" "+strings.Join(args, " "))
}
func GetCommandOutput(name string, args ...string) string {
	fmt.Printf("▶️  Getting output from: %s %s\n", name, strings.Join(args, " "))
	cmd := exec.Command(name, args...)
	output, err := cmd.Output()
	CheckError(err, "Lỗi khi lấy output từ lệnh "+name)
	return strings.TrimSpace(string(output))
}
