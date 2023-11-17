{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aldente";
  version = "1.22.3";

  src = fetchurl {
    url = "https://github.com/davidwernhart/aldente-charge-limiter/releases/download/${finalAttrs.version}/AlDente.dmg";
    hash = "sha256-pSqBDDumCbORLQ+B3skSqKmgG2KybR5Zb4ojiNQcAaM=";
  };

  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  # AlDente.dmg is not HFS formatted, default unpackPhase fails
  # https://discourse.nixos.org/t/help-with-error-only-hfs-file-systems-are-supported-on-ventura
  unpackCmd = ''
    if ! [[ "$curSrc" =~ \.dmg$ ]]; then return 1; fi
    mnt=$(mktemp -d -t ci-XXXXXXXXXX)

    function finish {
      /usr/bin/hdiutil detach $mnt -force
    }
    trap finish EXIT

    /usr/bin/hdiutil attach -nobrowse -readonly $src -mountpoint $mnt

    shopt -s extglob
    DEST="$PWD"
    (cd "$mnt"; cp -a !(Applications) "$DEST/")
  '';

  sourceRoot = "AlDente.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/AlDente.app
    cp -R . $out/Applications/AlDente.app

    runHook postInstall
  '';

  meta = with lib; {
    description = "macOS tool to limit maximum charging percentage";
    homepage = "https://apphousekitchen.com";
    changelog = "https://github.com/davidwernhart/aldente-charge-limiter/releases/tag/${finalAttrs.version}";
    license = with licenses; [ unfree ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ stepbrobd ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
  };
})
