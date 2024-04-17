{ lib
, stdenvNoCC
, requireFile
, undmg
, pname
, version
, meta
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version meta;

  src = requireFile rec {
      name = "VNC-Viewer-${finalAttrs.version}-MacOSX-universal.dmg";
      url = "https://downloads.realvnc.com/download/file/viewer.files/${name}";
      sha256 = "0k72fdnx1zmyi9z5n3lazc7s70gcddxq0s73akp0al0y9hzq9prh";
      message= ''
        vnc-viewer can be downloaded from ${url},
        but the download link require captcha, thus if you wish to use this application,
        you need to download it manually and use follow command to add downloaded files into nix-store

        $ nix-prefetch-url --type sha256 file:///path/to/${name}
      '';
  };
  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';
})
