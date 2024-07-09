import * as fs from "fs"
import * as path from "path"

export function createContext(context: string) {
  const contextDir = path.join("src", context)
  const testContextDir = path.join("test", context)

  fs.mkdirSync(contextDir, { recursive: true })
  fs.mkdirSync(testContextDir, { recursive: true })

  console.log(`Context ${context} created.`)
}
