#!/bin/bash

# Spotify Downloader Installation Script
# Run this after setting up a new Mac with macsetup

echo "🎵 Installing Spotify Downloader..."

# Install spotDL
echo "📦 Installing spotDL..."
pip3 install "spotdl==4.2.8"

# Create local bin directory
echo "📁 Creating local bin directory..."
mkdir -p ~/.local/bin

# Copy and set up the script
echo "📜 Setting up spotify-download script..."
cp ~/.macsetup/scripts/spotify-download ~/.local/bin/
chmod +x ~/.local/bin/spotify-download

# Create Desktop/Spotify directory
echo "📂 Creating download directory..."
mkdir -p ~/Desktop/Spotify

echo "✅ Installation complete!"
echo ""
echo "🎯 Usage:"
echo "  spotify https://open.spotify.com/playlist/PLAYLIST_ID"
echo ""
echo "📁 Downloads go to: ~/Desktop/Spotify/"
