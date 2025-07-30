package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"
)

func checkError(err error, message string) {
	if err != nil {
		log.Fatalf("%s: %v", message, err)
	}
}
func runCommand(name string, args ...string) {
	fmt.Printf("Running command: %s %s\n", name, strings.Join(args, " "))
	cmd := exec.Command(name, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	checkError(cmd.Run(), "lỗi khi chạy lệnh"+name+" "+strings.Join(args, " "))
}
func getCommandOutput(name string, args ...string) string {
	fmt.Printf("▶️  Getting output from: %s %s\n", name, strings.Join(args, " "))
	cmd := exec.Command(name, args...)
	output, err := cmd.Output()
	checkError(err, "Lỗi khi lấy output từ lệnh "+name)
	return strings.TrimSpace(string(output))
}
func handlePullOriginMain() {
	fmt.Println("Pulling from origin main")
	runCommand("git", "pull", "origin", "main")
	fmt.Println("Pulled from origin main successfully\n")
}
func handleCommit(args []string) {
	if len(args) < 1 {
		log.Fatalf("Bug when commit code, please provide a commit message")
	}
	commitMessage := args[0]
	fmt.Println("Starting commit code")
	runCommand("git", "add", ".")
	runCommand("git", "commit", "-m", commitMessage)
	fmt.Println("Commit code completed successfully")
}
func handlePushToOrigin() {
	currentBranch := getCommandOutput("git", "branch", "--show-current")
	fmt.Printf("Pushing to branch: %s\n", currentBranch)
	runCommand("git", "push", "origin", currentBranch)
	fmt.Println("Pushed to origin successfully")
}

func main() {
	log.SetFlags(0)

	if len(os.Args) < 2 {
		fmt.Println("Usage: git-collapse-command <command> [args...]")
		os.Exit(1)
	}

	command := os.Args[1]
	args := os.Args[2:]
	switch command {
	case "pom":
		handlePullOriginMain()
	case "cm":
		handleCommit(args)
	case "po":
		handlePushToOrigin()
	default:
		log.Fatalf("Lệnh không hợp lệ: %s", command)
	}

}
