{ lib
, appimageTools
, fetchurl
, makeWrapper
, gtk3
, gsettings-desktop-schemas
, pname
, version
, hash
, metaCommon ? { }
}:

let
  pname = "losslesscut";

  src = fetchurl {
    url = "https://github.com/mifi/lossless-cut/releases/download/v${version}/LosslessCut-linux-x86_64.AppImage";
    inherit hash;
  };

  extracted = appimageTools.extractType2 {
    inherit pname version src;
  };
in
(appimageTools.wrapType2 {
  inherit pname version src;

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  extraPkgs = ps: appimageTools.defaultFhsEnvArgs.multiPkgs ps;

  extraInstallCommands = ''
    mv $out/bin/{${pname}-${version},losslesscut}
    (
      mkdir -p $out/share
      cd ${extracted}/usr
      find share -mindepth 1 -type d -exec mkdir -p $out/{} \;
      find share -mindepth 1 -type f,l -exec ln -s $PWD/{} $out/{} \;
    )
    ln -s ${extracted}/losslesscut.png $out/share/icons/losslesscut.png
    mkdir $out/share/applications
    cp ${extracted}/losslesscut.desktop $out/share/applications
    substituteInPlace $out/share/applications/losslesscut.desktop \
      --replace AppRun losslesscut
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram "$out/bin/losslesscut" \
      --add-flags "--disable-seccomp-filter-sandbox"
  '';

  meta = metaCommon // {
    platforms = [ "x86_64-linux" ];
    mainProgram = "losslesscut";
  };
}) // {
  inherit pname version;
}
