# Michael's Command Center — Automated Vercel Deployment
# Run this in PowerShell in C:\Projects\michael_command_center\

Write-Host ""
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  MICHAEL'S COMMAND CENTER — VERCEL DEPLOYMENT AUTOMATION" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$projectPath = "C:\Projects\michael_command_center"

# Verify project exists
if (!(Test-Path $projectPath)) {
    Write-Host "❌ ERROR: Project not found at $projectPath" -ForegroundColor Red
    Write-Host "Please create the directory and add the files first." -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Project verified: $projectPath" -ForegroundColor Green

# Check npm
if (!(Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "❌ npm not installed. Install Node.js from https://nodejs.org/" -ForegroundColor Red
    exit 1
}

Write-Host "✅ npm ready: $(npm --version)" -ForegroundColor Green
Write-Host ""

# Install Vercel CLI
Write-Host "📦 Checking Vercel CLI..." -ForegroundColor Yellow
if (!(Get-Command vercel -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Vercel CLI (this may take a minute)..." -ForegroundColor Yellow
    npm install -g vercel 2>&1 | Out-Null
    if (!$?) {
        Write-Host "❌ Failed to install Vercel CLI" -ForegroundColor Red
        exit 1
    }
}
Write-Host "✅ Vercel CLI ready" -ForegroundColor Green
Write-Host ""

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  STEP 1 OF 3: LOGIN TO VERCEL" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Running: vercel login" -ForegroundColor White
Write-Host ""

vercel login

if (!$?) {
    Write-Host "❌ Login failed. Please try again." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ Logged in successfully" -ForegroundColor Green
Write-Host ""

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  STEP 2 OF 3: DEPLOY TO VERCEL" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "This will deploy your dashboard and API to Vercel..." -ForegroundColor White
Write-Host ""

cd $projectPath
vercel --prod

if (!$?) {
    Write-Host "❌ Deployment failed. Check your Vercel account." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ Deployment complete!" -ForegroundColor Green
Write-Host ""

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  STEP 3 OF 3: ADD CLAUDE API KEY" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "You will be prompted to paste your Claude API key (sk-ant-*)." -ForegroundColor Yellow
Write-Host "Get it from: https://console.anthropic.com" -ForegroundColor Cyan
Write-Host ""

vercel env add CLAUDE_API_KEY

if (!$?) {
    Write-Host "❌ Failed to add API key" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ API key added to Vercel" -ForegroundColor Green
Write-Host ""

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  FINAL STEP: REDEPLOY WITH API KEY" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Redeploying with your API key..." -ForegroundColor White
Write-Host ""

vercel --prod

Write-Host ""
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✅ DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""

Write-Host "🎉 Your Vercel URL is ready. Now you need to:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Copy your Vercel deployment URL (from the output above)" -ForegroundColor White
Write-Host "   It looks like: https://michael-command-center-abc123.vercel.app" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Edit C:\Projects\michael_command_center\dashboard.html" -ForegroundColor White
Write-Host "   Find this line near the top:" -ForegroundColor White
Write-Host "     const VERCEL_URL = 'https://your-vercel-url.vercel.app';" -ForegroundColor Cyan
Write-Host "   Replace 'your-vercel-url' with your actual URL" -ForegroundColor Yellow
Write-Host ""
Write-Host "3. Save and commit to GitHub:" -ForegroundColor White
Write-Host "     git add ." -ForegroundColor Cyan
Write-Host "     git commit -m 'add vercel backend integration'" -ForegroundColor Cyan
Write-Host "     git push" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. Open your dashboard:" -ForegroundColor White
Write-Host "   https://Mgregory2K.github.io/michael-command-center/dashboard.html" -ForegroundColor Cyan
Write-Host ""
Write-Host "5. Test the AI features!" -ForegroundColor White
Write-Host ""

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  Questions?" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

Write-Host " Full guide: VERCEL-SETUP-GUIDE.txt" -ForegroundColor White
Write-Host ""

