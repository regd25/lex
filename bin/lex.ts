#!/usr/bin/env bun

import { initProject } from "../src/commands/init"
import { createContext } from "../src/commands/new-context"
import { createService } from "../src/commands/new-service"
import { deployService } from "../src/commands/deploy"

const args = process.argv.slice(2)

switch (args[0]) {
  case "init":
    initProject(args[1])
    break
  case "new":
    if (!args[1]) {
      console.error("Context name is required.")
      process.exit(1)
    }
    createContext(args[1])
    break
  case "deploy":
    if (args.length < 3) {
      console.error("Context and service names are required.")
      process.exit(1)
    }
    deployService(args[1], args[2])
    break
  default:
    if (args.length === 3 && args[1] === "new") {
      createService(args[0], args[2])
    } else {
      console.error("Invalid command.")
      process.exit(1)
    }
    break
}
