import { execSync } from 'child_process';
import * as fs from 'fs';
import * as path from 'path';

export function initProject(name?: string) {
  const projectName = name || path.basename(process.cwd());
  const rootDir = name ? path.join(process.cwd(), projectName) : process.cwd();
  const lexFile = path.join(rootDir, '.lex');
  const srcDir = path.join(rootDir, 'src');
  const testDir = path.join(rootDir, 'test');

  if (!fs.existsSync(rootDir)) {
    fs.mkdirSync(rootDir);
  }

  fs.writeFileSync(lexFile, JSON.stringify({ projectName }, null, 2));
  fs.mkdirSync(srcDir, { recursive: true });
  fs.mkdirSync(testDir, { recursive: true });

  console.log(`Project ${projectName} initialized.`);
  console.log(`Run 'aws configure' to set up your AWS credentials.`);
  execSync('bun add aws-cdk', { stdio: 'inherit' });
}