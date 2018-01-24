#!/bin/bash
accept="application/vnd.github.v3+json"
base_url="https://api.github.com"

owner="discordapp"
repo="discord-rpc"

curl -H "Accept: $accept" \
    "$base_url/repos/$owner/$repo/releases/latest" > latest.json

./gradlew clean setup
resources="src/main/resources"
echo moving binaries...
mv "win/discord-rpc/win64-dynamic/lib/discord-rpc.lib" "$resources/win32-x86-64/discord-rpc.dll"
mv "win/discord-rpc/win32-dynamic/lib/discord-rpc.lib" "$resources/win32-x86/discord-rpc.dll"
mv "linux/discord-rpc/linux-dynamic/lib/libdiscord-rpc.so" "$resources/linux-x86-64/libdiscord-rpc.so"
mv "osx/discord-rpc/osx-dynamic/lib/libdiscord-rpc.dylib" "$resources/darwin/libdiscord-rpc.dylib"

version=$(<tag_name.txt)
rm latest.json tag_name.txt
echo starting compilation...
./gradlew build

rm -rf linux win osx

git add *
git status

echo
echo "Current tags:"
git tag
echo
echo "To be added: $version"

read -n1 -p "Press any key to continue..."

git commit -m "Updated to release $version"
git tag -a $version -m $version
git push --tags origin master
