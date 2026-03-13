# Install Node.js and npm on Windows

## Option 1: Download from nodejs.org (Recommended)

1. Go to [https://nodejs.org/](https://nodejs.org/)
2. Download the **LTS (Long Term Support)** version (recommended for stability)
3. Run the installer
4. Follow the installation wizard:
   - Click "Next" through all steps (default settings are fine)
   - Make sure "npm package manager" is checked ✓
5. Restart your PowerShell/Command Prompt after installation

## Option 2: Use Chocolatey (Windows Package Manager)

If you have Chocolatey installed:

```powershell
# Run PowerShell as Administrator
choco install nodejs
```

## Option 3: Use Windows Package Manager (winget)

```powershell
# PowerShell (Windows 10/11+)
winget install OpenJS.NodeJS
```

## Verify Installation

After installation, open a **NEW PowerShell/Command Prompt window** and run:

```powershell
node --version
npm --version
```

You should see version numbers like:
- `v18.16.0` (Node.js)
- `9.6.7` (npm)

## Troubleshooting

### PowerShell Still Says "npm not recognized"
- Make sure you closed and reopened PowerShell AFTER installing
- Try running PowerShell as Administrator
- Check if Node.js was installed in Program Files correctly

### To verify installation location:
```powershell
where node
where npm
```

This will show you the full path to node and npm executables.

## Next Steps

Once npm is installed and verified:

```powershell
# 1. Navigate to your project
cd "c:\Users\LAB\Desktop\Midterm_Labtest\flutter_application_1"

# 2. Install Firebase CLI
npm install -g firebase-tools

# 3. Install FlutterFire CLI
dart pub global activate flutterfire_cli

# 4. Then follow the deployment guide in README-FIREBASE.md
```

## Common Issues

**"npm ERR! code EACCES"** on Windows:
- Usually means Windows Defender or antivirus is blocking
- Try running PowerShell as Administrator

**"npm WARN" messages**: 
- These are just warnings, not errors
- Installation should still succeed

**Still having issues?**
- Restart your computer and try again
- Check that Node.js appears in Control Panel → Programs to verify it installed
