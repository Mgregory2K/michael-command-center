# Michael's Command Center — Vercel Auto-Deploy
# Run this in PowerShell from C:\Projects\michael_command_center\

Write-Host ""
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  DEPLOYING TO VERCEL" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Check files exist
if (!(Test-Path "dashboard.html")) {
    Write-Host "ERROR: dashboard.html not found" -ForegroundColor Red
    exit 1
}

if (!(Test-Path "vercel.json")) {
    Write-Host "ERROR: vercel.json not found" -ForegroundColor Red
    exit 1
}

if (!(Test-Path "api/claude.js")) {
    Write-Host "ERROR: api/claude.js not found" -ForegroundColor Red
    exit 1
}

Write-Host "✅ All files found" -ForegroundColor Green
Write-Host ""

# Install Vercel if needed
if (!(Get-Command vercel -ErrorAction SilentlyContinue)) {
    Write-Host "📦 Installing Vercel CLI..." -ForegroundColor Yellow
    npm install -g vercel
}

Write-Host "✅ Vercel CLI ready" -ForegroundColor Green
Write-Host ""

Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  STEP 1: Login to Vercel" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

vercel login

Write-Host ""
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  STEP 2: Deploy to Vercel (production)" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$deployment = vercel --prod

Write-Host $deployment
Write-Host ""

# Extract URL
$url = $deployment | Select-String -Pattern "https://[a-z0-9-]+\.vercel\.app" | ForEach-Object { $_.Matches.Value } | Select-Object -First 1

if ($url) {
    Write-Host "✅ Deployment URL: $url" -ForegroundColor Green
} else {
    Write-Host "⚠️  Could not extract URL. Check Vercel dashboard at https://vercel.com" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  STEP 3: Add Claude API Key to Vercel" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "You will be prompted to paste your Claude API key (sk-ant-*)" -ForegroundColor Yellow
Write-Host "Get it from: https://console.anthropic.com" -ForegroundColor Cyan
Write-Host ""

vercel env add CLAUDE_API_KEY

Write-Host ""
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  STEP 4: Redeploy with API Key" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

vercel --prod

Write-Host ""
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✅ DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""

if ($url) {
    Write-Host "Your Vercel URL: $url" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📝 FINAL STEP: Edit dashboard.html" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Find this line (near the top):" -ForegroundColor White
    Write-Host "  const VERCEL_URL = 'https://your-vercel-url.vercel.app';" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Replace 'your-vercel-url' with your actual URL:" -ForegroundColor White
    Write-Host "  const VERCEL_URL = '$url';" -ForegroundColor Green
    Write-Host ""
}

Write-Host "Then commit and push:" -ForegroundColor White
Write-Host "  git add ." -ForegroundColor Cyan
Write-Host "  git commit -m 'add vercel backend'" -ForegroundColor Cyan
Write-Host "  git push" -ForegroundColor Cyan
Write-Host ""

Write-Host "Done! Open your dashboard at:" -ForegroundColor Cyan
Write-Host "  https://Mgregory2K.github.io/michael-command-center/dashboard.html" -ForegroundColor Green
Write-Host ""

