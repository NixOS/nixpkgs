{ lib, stdenvNoCC, fetchurl }:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "linearmouse";
  version = "0.9.5";

  src = fetchurl {
    url = "https://github.com/linearmouse/linearmouse/releases/download/v${finalAttrs.version}/LinearMouse.dmg";
    hash = "sha256-T25H2CmDBt3J5zaC8gy87PyJONPsDZpF7S5eksRzgrA=";
  };

  sourceRoot = "LinearMouse.app";

  # `undmg` doesn't support unpacking APFS dmgs, so we use some of the macOS built-ins to do it for us.
  # https://discourse.nixos.org/t/help-with-error-only-hfs-file-systems-are-supported-on-ventura/25873
  unpackCmd = ''
    echo "File to unpack: $curSrc"
    if ! [[ "$curSrc" =~ \.dmg$ ]]; then return 1; fi
    mnt=$(mktemp -d -t ci-XXXXXXXXXX)

    function finish {
      echo "Detaching $mnt"
      /usr/bin/hdiutil detach $mnt -force
      rm -rf $mnt
    }
    trap finish EXIT

    echo "Attaching $mnt"
    /usr/bin/hdiutil attach -nobrowse -readonly $src -mountpoint $mnt

    # echo "What's in the mount dir"?
    echo "What is inside?"
    ls -la $mnt/

    echo "Copying contents"
    cp -a $mnt/LinearMouse.app "$PWD/"
  '';

  installPhase = ''
    mkdir -p "$out/Applications/LinearMouse.app"
    cp -a ./. "$out/Applications/LinearMouse.app/"
  '';

  meta = {
    description = "The mouse and trackpad utility for Mac";
    homepage = "https://github.com/linearmouse/linearmouse";
    license = lib.licenses.mit;
    mainProgram = "LinearMouse";
    maintainers = [];
    platforms = lib.platforms.darwin;
  };
})
