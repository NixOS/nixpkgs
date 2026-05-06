#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl git gnutar jq moreutils nix

set -eu -o pipefail

if [ ! -v 1 ]; then
    echo "usage: update-source-releases.sh <macOS version>" >&2
    echo " <macOS version>   Decimal-separated version number." >&2
    echo "                   Must correspond to a tag in https://github.com/apple-oss-distributions/distribution-macOS" >&2
    exit 1
fi

pkgdir=$(dirname "$(realpath "$0")")

lockfile=$pkgdir/versions.json
if [ -e "$lockfile" ]; then
    echo '{}' > "$lockfile"
fi

workdir=$(mktemp -d)
trap 'rm -rf -- "$workdir"' EXIT

sdkVersion=$1; shift
tag="macos-${sdkVersion//.}"

declare -a packages=(
  AvailabilityVersions
  CarbonHeaders
  CommonCrypto
  Csu
  ICU
  IOAudioFamily
  IOBDStorageFamily
  IOCDStorageFamily
  IODVDStorageFamily
  IOFWDVComponents
  IOFireWireAVC
  IOFireWireFamily
  IOFireWireSBP2
  IOFireWireSerialBusProtocolTransport
  IOGraphics
  IOHIDFamily
  IOKitTools
  IOKitUser
  IONetworkingFamily
  IOSerialFamily
  IOStorageFamily
  IOUSBFamily
  Libc
  Libinfo
  Libm
  Libnotify
  Librpcsvc
  Libsystem
  OpenDirectory
  PowerManagement
  Security
  adv_cmds
  architecture
  basic_cmds
  bootstrap_cmds
  configd
  copyfile
  developer_cmds
  diskdev_cmds
  doc_cmds
  dtrace
  dyld
  eap8021x
  file_cmds
  hfs
  launchd
  libclosure
  libdispatch
  libffi
  libiconv
  libmalloc
  libpcap
  libplatform
  libpthread
  libresolv
  libutil
  mDNSResponder
  mail_cmds
  misc_cmds
  network_cmds
  objc4
  patch_cmds
  ppp
  remote_cmds
  removefile
  shell_cmds
  system_cmds
  text_cmds
  top
  xnu
)

echo "Locking versions for macOS $sdkVersion using tag '$tag'..."

pushd "$workdir" > /dev/null

git clone --branch "$tag" https://github.com/apple-oss-distributions/distribution-macOS.git &> /dev/null
cd distribution-macOS

for package in "${packages[@]}"; do
    # If the tag exists in `release.json`, use that as an optimization to avoid downloading unnecessarily from Github.
    packageTag=$(jq -r --arg package "$package" '.projects[] | select(.project == $package) | .tag' release.json)
    packageCommit=$(git ls-tree -d HEAD "$package" | awk '{print $3}')

    if [ ! -d "$package" ]; then
        packageCommit=HEAD
    fi

    # However, sometimes it doesn’t exist. In that case, fall back to cloning the repo and check manually
    # which tag corresponds to the commit from the submodule.
    if [ -z "$packageTag" ]; then
        git clone --no-checkout "https://github.com/apple-oss-distributions/$package.git" ../source &> /dev/null
        pushd ../source > /dev/null
        packageTag=$(git tag --points-at "$packageCommit")
        popd > /dev/null
        rm -rf ../source
    fi

    packageVersion=${packageTag##"$package"-}

    curl -OL "https://github.com/apple-oss-distributions/$package/archive/$packageTag.tar.gz" &> /dev/null
    tar axf "$packageTag.tar.gz"

    packageHash=$(nix --extra-experimental-features nix-command hash path "$package-$packageTag")

    pkgsjson="{\"$package\": {\"version\": \"$packageVersion\", \"hash\": \"$packageHash\"}}"

    echo "   - Locking $package to version $packageVersion with hash '$packageHash'"
    jq --argjson pkg "$pkgsjson" -S '. * $pkg' "$lockfile" | sponge "$lockfile"
done

popd > /dev/null
