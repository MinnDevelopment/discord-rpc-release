#!/sh
accept="application/vnd.github.v3+json"
base_url="https://api.github.com"

owner="discordapp"
repo="discord-rpc"

curl -H "Accept: $accept" \
     -H "Authorization: $GIT_OAUTH_TOKEN" \
    "$base_url/repos/$owner/$repo/releases/latest" > latest.json

./gradlew setup
resources="src/main/resources"
mv "win/discord-rpc/win64-dynamic/lib/discord-rpc.lib" "$resources/win32-x86-64/discord-rpc.dll"
mv "win/discord-rpc/win32-dynamic/lib/discord-rpc.lib" "$resources/win32-x86/discord-rpc.dll"
mv "linux/discord-rpc/linux-dynamic/lib/libdiscord-rpc.so" "$resources/linux-x86-64/libdiscord-rpc.so"
mv "osx/discord-rpc/osx-dynamic/lib/libdiscord-rpc.dylib" "$resources/darwin/libdiscord-rpc.dylib"

rm latest.json

./gradlew build

rm -rf linux win osx

