package main

import (
	"fmt"
	"log"
)

func handlePullOriginMain() {
	fmt.Println("Pulling from origin main")
	RunCommand("git", "pull", "origin", "main")
	fmt.Println("Pulled from origin main successfully\n")
}
func handleCommit(args []string) {
	if len(args) < 1 {
		log.Fatalf("Bug when commit code, please provide a commit message")
	}
	commitMessage := args[0]
	fmt.Println("Starting commit code")
	RunCommand("git", "add", ".")
	RunCommand("git", "commit", "-m", commitMessage)
	fmt.Println("Commit code completed successfully")
}
func handlePushToOrigin() {
	currentBranch := GetCommandOutput("git", "branch", "--show-current")
	fmt.Printf("Pushing to branch: %s\n", currentBranch)
	RunCommand("git", "push", "origin", currentBranch)
	fmt.Println("Pushed to origin successfully")
}
