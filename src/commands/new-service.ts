import * as fs from "fs"
import * as path from "path"

export function createService(context: string, service: string) {
  const serviceDir = path.join("src", context, service)
  const serviceTestDir = path.join("test", context, service)
  const subDirs = ["application", "domain", "infrastructure"]

  subDirs.forEach((subDir) => {
    fs.mkdirSync(path.join(serviceDir, subDir), { recursive: true })
    fs.mkdirSync(path.join(serviceTestDir, subDir), { recursive: true })
  })

  console.log(`Service ${service} created in context ${context}.`)
}
