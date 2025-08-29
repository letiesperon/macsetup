# Spotify Downloader Setup Guide

## 📝 Quick Summary
I have a super simple `spotify` command that downloads any Spotify playlist or song to my Desktop automatically!

```bash
spotify https://open.spotify.com/playlist/37i9dQZF1EIeUlD4ltrDTe
# Downloads to: ~/Desktop/Spotify/PlaylistName/
```

## 🛠 How It Works

### The Magic Command
- **Command**: `spotify <spotify_url>`
- **For playlists**: Downloads to `~/Desktop/Spotify/<PlaylistName>/`
- **For songs**: Downloads to `~/Desktop/Spotify/`
- **Format**: High-quality MP3 with metadata and album art
- **Source**: YouTube (using spotDL library)

### What's Installed
1. **spotDL** - Python library that downloads from YouTube using Spotify metadata
   - GitHub: https://github.com/spotDL/spotify-downloader
   - Version: 4.2.8 (compatible with Python 3.9)
   - Location: `/Users/letiesperon/Library/Python/3.9/bin/spotdl`
   - No Spotify API keys required! 🎉

2. **Custom Script** - Wrapper that makes everything easy
   - Location: `/Users/letiesperon/.local/bin/spotify-download`
   - Handles folder creation, playlist naming, error handling
   - Opens Finder when done

3. **Shell Alias** - The magic `spotify` command
   - Added to my `.zshrc`: `alias spotify='/Users/letiesperon/.local/bin/spotify-download'`
   - Script is NOT in PATH (only accessible via alias to ensure single usage method)

## 🔧 Setup on New Mac

### If using my macsetup (RECOMMENDED):
1. Run my macsetup script (this will restore my .zshrc with the alias)
2. Install Python 3.9+ (should be installed by my macsetup)
3. Install spotDL: `pip3 install "spotdl==4.2.8"`
4. Copy the script: `cp ~/.macsetup/scripts/spotify-download ~/.local/bin/`
5. Make executable: `chmod +x ~/.local/bin/spotify-download`
6. Done! Use `spotify <url>`

### Manual Setup (if needed):
```bash
# 1. Install spotDL
pip3 install "spotdl==4.2.8"

# 2. Create the script directory
mkdir -p ~/.local/bin

# 3. Create the download script
nano ~/.local/bin/spotify-download
chmod +x ~/.local/bin/spotify-download

# 4. Add alias to .zshrc
echo "alias spotify='~/.local/bin/spotify-download'" >> ~/.zshrc
source ~/.zshrc
```

## 🎯 Examples

```bash
# Download a playlist
spotify https://open.spotify.com/playlist/37i9dQZF1EIeUlD4ltrDTe
# → ~/Desktop/Spotify/Swimming_Pop_Mix/

# Download a song
spotify https://open.spotify.com/track/4iV5W9uYEdYUVa79Axb7Rh
# → ~/Desktop/Spotify/

# Get help
spotify
# Shows usage instructions
```

## 🚨 Troubleshooting

### Command not found
```bash
# Check if alias exists
alias | grep spotify

# Check if script exists and is executable
ls -la ~/.local/bin/spotify-download

# Reload shell config
source ~/.zshrc
```

### Python version issues
```bash
# Check Python version (needs 3.9+)
python3 --version

# If spotDL complains about Python version, install older version:
pip3 install "spotdl==4.2.8"
```

### Downloads failing
- Some songs may fail (this is normal with YouTube sources)
- Script will continue and download what it can
- Check the output folder for successfully downloaded files

## 📁 File Locations

```
~/.local/bin/spotify-download          # Main script
~/.zshrc                              # Contains the alias
~/Desktop/Spotify/                    # Download destination
~/Library/Python/3.9/bin/spotdl      # spotDL binary
```

---
*Last updated: August 2025*
*Script created using Claude Code*
