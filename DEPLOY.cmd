@echo off
REM Michael's Command Center — One-Click Vercel Deployment
REM Run this from C:\Projects\michael_command_center\

setlocal enabledelayedexpansion

echo.
echo ════════════════════════════════════════════════════════════
echo   MICHAEL'S COMMAND CENTER — AUTO DEPLOY
echo ════════════════════════════════════════════════════════════
echo.

REM Check if in right directory
if not exist dashboard.html (
    echo ERROR: dashboard.html not found in current directory
    echo Please run this from C:\Projects\michael_command_center\
    pause
    exit /b 1
)

echo Checking dependencies...
npm --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: npm not installed. Install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

echo Checking Vercel CLI...
vercel --version >nul 2>&1
if errorlevel 1 (
    echo Installing Vercel CLI...
    call npm install -g vercel
)

echo.
echo ════════════════════════════════════════════════════════════
echo   STEP 1: LOGIN TO VERCEL
echo ════════════════════════════════════════════════════════════
echo.
call vercel login
if errorlevel 1 (
    echo Login failed
    pause
    exit /b 1
)

echo.
echo ════════════════════════════════════════════════════════════
echo   STEP 2: DEPLOY TO VERCEL
echo ════════════════════════════════════════════════════════════
echo.
call vercel --prod
if errorlevel 1 (
    echo Deployment failed
    pause
    exit /b 1
)

echo.
echo ════════════════════════════════════════════════════════════
echo   STEP 3: ADD CLAUDE API KEY
echo ════════════════════════════════════════════════════════════
echo.
echo Paste your Claude API key (sk-ant-*) when prompted:
call vercel env add CLAUDE_API_KEY

echo.
echo ════════════════════════════════════════════════════════════
echo   STEP 4: REDEPLOY WITH KEY
echo ════════════════════════════════════════════════════════════
echo.
call vercel --prod

echo.
echo ════════════════════════════════════════════════════════════
echo   SUCCESS!
echo ════════════════════════════════════════════════════════════
echo.
echo Now edit dashboard.html and replace:
echo   const VERCEL_URL = 'https://your-vercel-url.vercel.app';
echo with your actual Vercel URL (shown above)
echo.
echo Then:
echo   git add .
echo   git commit -m "add vercel backend"
echo   git push
echo.
pause

