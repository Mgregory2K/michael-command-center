#!/usr/bin/env node

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

function log(msg, color = 'white') {
  const colors = {
    green: '\x1b[32m',
    red: '\x1b[31m',
    yellow: '\x1b[33m',
    cyan: '\x1b[36m',
    white: '\x1b[37m',
    reset: '\x1b[0m'
  };
  console.log(`${colors[color]}${msg}${colors.reset}`);
}

function header(text) {
  log('', 'cyan');
  log('════════════════════════════════════════════════════════════', 'cyan');
  log(`  ${text}`, 'cyan');
  log('════════════════════════════════════════════════════════════', 'cyan');
  log('', 'cyan');
}

function checkFiles() {
  header('CHECKING FILES');
  const files = ['dashboard.html', 'vercel.json', 'api/claude.js', 'package.json'];
  let ok = true;
  
  for (const file of files) {
    if (fs.existsSync(file)) {
      log(`✅ ${file}`, 'green');
    } else {
      log(`❌ ${file} not found`, 'red');
      ok = false;
    }
  }
  
  if (!ok) {
    log('Please make sure all files are in the current directory', 'red');
    process.exit(1);
  }
  log('All files found', 'green');
}

function runCommand(cmd, label) {
  log(`Running: ${cmd}`, 'white');
  try {
    execSync(cmd, { stdio: 'inherit', shell: true, env: { ...process.env, PATH: process.env.PATH } });
    return true;
  } catch (err) {
    log(`${label} failed`, 'red');
    return false;
  }
}

async function main() {
  log('', 'cyan');
  log('MICHAEL\'S COMMAND CENTER — VERCEL DEPLOYMENT', 'cyan');
  log('', 'cyan');

  checkFiles();

  // Step 1: Login
  header('STEP 1: LOGIN TO VERCEL');
  log('You will be redirected to Vercel in your browser', 'yellow');
  log('', 'white');
  
  if (!runCommand('npx vercel login', 'Login')) {
    process.exit(1);
  }

  // Step 2: Deploy
  header('STEP 2: DEPLOY TO VERCEL');
  log('Deploying to production...', 'yellow');
  log('', 'white');
  
  if (!runCommand('npx vercel --prod', 'Deployment')) {
    process.exit(1);
  }

  // Step 3: Add API key
  header('STEP 3: ADD CLAUDE API KEY');
  log('Paste your Claude API key when prompted (sk-ant-*)', 'yellow');
  log('Get it from: https://console.anthropic.com', 'cyan');
  log('', 'white');
  
  if (!runCommand('npx vercel env add CLAUDE_API_KEY', 'API Key setup')) {
    process.exit(1);
  }

  // Step 4: Redeploy
  header('STEP 4: REDEPLOY WITH API KEY');
  log('Redeploying with your API key...', 'yellow');
  log('', 'white');
  
  if (!runCommand('npx vercel --prod', 'Redeploy')) {
    process.exit(1);
  }

  // Done
  header('✅ DEPLOYMENT COMPLETE');
  log('', 'cyan');
  log('NEXT STEPS:', 'yellow');
  log('', 'white');
  log('1. Get your Vercel URL from the output above', 'white');
  log('   (looks like: michael-command-center-abc123.vercel.app)', 'cyan');
  log('', 'white');
  log('2. Edit dashboard.html and find this line (near top):', 'white');
  log("   const VERCEL_URL = 'https://your-vercel-url.vercel.app';", 'cyan');
  log('', 'white');
  log('3. Replace with your actual URL:', 'white');
  log("   const VERCEL_URL = 'https://your-actual-url.vercel.app';", 'green');
  log('', 'white');
  log('4. Commit and push:', 'white');
  log('   git add .', 'cyan');
  log('   git commit -m "add vercel backend"', 'cyan');
  log('   git push', 'cyan');
  log('', 'white');
  log('5. Open your dashboard:', 'white');
  log('   https://Mgregory2K.github.io/michael-command-center/dashboard.html', 'green');
  log('', 'cyan');
}

main().catch(err => {
  log(`Error: ${err.message}`, 'red');
  process.exit(1);
});
