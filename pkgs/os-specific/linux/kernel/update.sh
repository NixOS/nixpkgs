#!/usr/bin/env bash
set -e

# Get the latest versions from kernel.org
LINUXSED='s/.*linux-\([0-9]\+\(.[0-9]\+\)*\).*/\1/p'
KDATA="$(curl -s https://www.kernel.org | sed -n -e '/Download complete/p')"
VERSIONS=($(sed -n -e $LINUXSED <<< "$KDATA" | sort -Vr))

# Remove mainline version if there is a stable update
# Note due to sorting these two will always exist at the bottom
if grep -q "^${VERSIONS[1]}" <<< "${VERSIONS[0]}"; then
  VERSIONS=(${VERSIONS[@]:0:1} ${VERSIONS[@]:2})
fi

# Inspect each file and see if it has the latest version
NIXPKGS="$(git rev-parse --show-toplevel)"
ls $NIXPKGS/pkgs/os-specific/linux/kernel | while read FILE; do
  KERNEL="$(sed -n -e $LINUXSED <<< "$FILE")"
  [ -z "$KERNEL" ] && continue

  # Find the matching new kernel version
  MATCHING=""
  for V in "${VERSIONS[@]}"; do
    if grep -q "^$KERNEL" <<< "$V"; then
      MATCHING="$V"
      break
    fi
  done
  if [ -z "$MATCHING" ]; then
    echo "Out-of-support $KERNEL"
    continue
  fi

  # Inspect the nix expression to check for changes
  DATA="$(<$NIXPKGS/pkgs/os-specific/linux/kernel/$FILE)"
  URL="$(sed -n -e 's/.*url = "\(.*\)";.*/\1/p' <<< "$DATA" | sed -e "s/\${version}/$MATCHING/g")"
  OLDVER=$(sed -n -e 's/.*version = "\(.*\)".*/\1/p' <<< "$DATA")
  if [ "$OLDVER" = "$V" ]; then
    echo "No updates for $KERNEL"
    continue
  fi

  # Download the new file for the hash
  if ! HASH="$(nix-prefetch-url $URL 2>/dev/null)"; then
    echo "Failed to get hash of $URL"
    continue
  fi
  sed -i -e "s/sha256 = \".*\"/sha256 = \"$HASH\"/g" $NIXPKGS/pkgs/os-specific/linux/kernel/$FILE

  # Rewrite the expression
  sed -i -e '/version = /d' $NIXPKGS/pkgs/os-specific/linux/kernel/$FILE
  sed -i -e "\#buildLinux (args // rec {#a \  version = \"$V\";" $NIXPKGS/pkgs/os-specific/linux/kernel/$FILE

  # Commit the changes
  git add -u $NIXPKGS/pkgs/os-specific/linux/kernel/$FILE
  git commit -m "linux: $OLDVER -> $V" >/dev/null 2>&1

  echo "Updated $OLDVER -> $V"
done

# Update linux-libre
COMMIT=1 $NIXPKGS/pkgs/os-specific/linux/kernel/update-libre.sh
