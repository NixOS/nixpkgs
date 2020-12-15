{ lib
, buildGoModule
, buildFHSUserEnv
, dejavu_fonts
, pkgconfig
, fetchFromGitHub
, stdenv
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
  version = "0.43.0";

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

    meta = with stdenv.lib; {
      description = "A build tool to run Flutter applications on desktop";
      homepage = "https://github.com/go-flutter-desktop/hover";
      license = licenses.bsd3;
      platforms = platforms.linux ++ platforms.darwin;
      maintainers = [ maintainers.ericdallo maintainers.thiagokokada];
    };

    subPackages = [ "." ];

    vendorSha256 = "1wr08phjm87dxim47i8449rmq5wfscvjyz65g3lxmv468x209pam";

    src = fetchFromGitHub {
      rev = "v${version}";
      owner = "go-flutter-desktop";
      repo = pname;
      sha256 = "0iw6sxg86wfdbihl2hxzn43ppdzl1p7g5b9wl8ac3xa9ix8759ax";
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
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath libs}
    '';

    postFixup = ''
      addOpenGLRunpath $out/bin/hover
    '';
  };

in
buildFHSUserEnv rec {
  name = pname;
  targetPkgs = pkgs: [
    dejavu_fonts
    flutter
    gcc
    go
    hover
    pkgconfig
    roboto
  ] ++ libs;

  runScript = "hover";
}
