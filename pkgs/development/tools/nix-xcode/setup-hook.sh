fooPhase() {
  echo >&2 "patching references to Xcode utilities..."

  PATTERN="(/usr/bin/xcrun|/usr/bin/xcode-select|/usr/bin/xcodebuild|/usr/sbin/pkgutil)"

  while IFS= read -r fname
  do
    echo "patching $fname"
    substituteInPlace "$fname" \
      --replace "/usr/bin/xcrun" "@out@/bin/xcrun" \
      --replace "/usr/bin/xcode-select" "@out@/bin/xcode-select" \
      --replace "/usr/sbin/pkgutil" "@out@/bin/pkgutil" \
      --replace "/usr/bin/xcodebuild" "@out@/bin/xcodebuild"
  done < <(grep -Rl -E "$PATTERN" .)
}

preConfigureHooks+=(fooPhase)
