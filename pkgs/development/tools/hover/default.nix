{ lib
, buildGoModule
, buildFHSUserEnv
, binutils
, dejavu_fonts
, pkg-config
, fetchFromGitHub
, roboto
, writeScript
, xorg
, libglvnd
, addOpenGLRunpath
, makeWrapper
, gcc
, go
, flutter
}:

let
  pname = "hover";
  version = "0.47.0";

  libs = with xorg; [
    libX11.dev
    libXcursor.dev
    libXext.dev
    libXi.dev
    libXinerama.dev
    libXrandr.dev
    libXrender.dev
    libXfixes.dev
    libXxf86vm
    libglvnd.dev
    xorgproto
  ];
  hover = buildGoModule rec {
    inherit pname version;

    meta = with lib; {
      description = "A build tool to run Flutter applications on desktop";
      homepage = "https://github.com/go-flutter-desktop/hover";
      license = licenses.bsd3;
      platforms = platforms.linux;
      maintainers = with maintainers; [ ericdallo flexagoon ];
    };

    subPackages = [ "." ];

    vendorSha256 = "sha256-GDoX5d2aDfaAx9JsKuS4r8137t3swT6rgcCghmaThSM=";

    src = fetchFromGitHub {
      rev = "v${version}";
      owner = "go-flutter-desktop";
      repo = pname;
      sha256 = "sha256-ch59Wx4g72u7x99807ppURI4I+5aJ/W8Zr35q8X68v4=";
    };

    nativeBuildInputs = [ addOpenGLRunpath makeWrapper ];

    buildInputs = libs;

    checkRun = false;

    patches = [
      ./fix-assets-path.patch
    ];

    postPatch = ''
      sed -i 's|@assetsFolder@|'"''${out}/share/assets"'|g' internal/fileutils/assets.go
    '';

    postInstall = ''
      mkdir -p $out/share
      cp -r assets $out/share/assets
      chmod -R a+rx $out/share/assets

      wrapProgram "$out/bin/hover" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath libs}
    '';

    postFixup = ''
      addOpenGLRunpath $out/bin/hover
    '';
  };

in
buildFHSUserEnv rec {
  name = pname;
  targetPkgs = pkgs: [
    binutils
    dejavu_fonts
    flutter
    gcc
    go
    hover
    pkg-config
    roboto
  ] ++ libs;

  runScript = "hover";
}
