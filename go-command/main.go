package main

import (
	"fmt"
	"log"
	"os"
)

func main() {
	// Install snap package

	// Initialize the git collapse command
	setupGitCollapseCommand()
}

func setupGitCollapseCommand() {
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
