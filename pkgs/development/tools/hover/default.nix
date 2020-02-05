{ buildGoPackage, fetchFromGitHub, fetchurl, glfw, libGL, libX11, libXcursor, libXi,
  libXinerama, libXrandr, libXxf86vm, makeWrapper, pkgconfig, stdenv, unzip}:

buildGoPackage rec {
  pname = "hover";
  version = "unstable-2020-01-23";
  rev = "a6f11fe3c4946c9e7cce75360902bd79a077ccf4";

  goPackagePath = "github.com/go-flutter-desktop/hover";

  srcs =
    [ (fetchFromGitHub {
      inherit rev;
      owner = "go-flutter-desktop";
      repo = pname;
      sha256 = "0pwdzd34zcbyspl7qiwfcrppr6zxp2zliqg9n8s6s3l6k7mffl9j";
    })
      (fetchurl {
        name = "libflutter_engine.zip";
        url = "https://storage.googleapis.com/flutter_infra/flutter/051762798888ebea4666c5f9c9f4c0e4d3b3b481/linux-x64/linux-x64-embedder";
        sha256 = "15p6cdvi6rajjs6vv79y7vsrwwpg2kk9qlg14891wrmdn9nvpqb4";
        postFetch = "${unzip}/bin/unzip $downloadedFile";
      })
    ];

  nativeBuildInputs = [ pkgconfig unzip makeWrapper ];

  buildInputs = [ glfw
                  libX11
                  libXcursor
                  libXinerama
                  libXrandr
                  libXxf86vm
                  libXi
                  libGL
                ];

  goDeps = ./deps.nix;

  NIX_CFLAGS_COMPILE = "-Wno-error=format-truncation";

  patches = [
    ./fix-assets-path.patch
    ./fix-build-docker.patch
  ];
  postPatch = ''
    sed -i 's|@assetsFolder@|'"''${bin}/share/assets"'|g' internal/fileutils/assets.go
  '';

  preBuildPhases = ["preBuildPhase"];
  preBuildPhase = ''
     lib=$(mktemp -d)
     mv libflutter_engine.so $lib/
     export NIX_LDFLAGS="$NIX_LDFLAGS -L$lib"
  '';

  postInstall = ''
    mkdir -p $bin/share
    cp -r go/src/github.com/go-flutter-desktop/hover/assets $bin/share/assets
    chmod -R a+rx $bin/share/assets

    wrapProgram "$bin/bin/hover" --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ glfw libX11 libXcursor libXinerama libXrandr libXxf86vm libXi libGL]}
  '';

  meta = with stdenv.lib; {
    description = "A build tool to run Flutter applications on desktop";
    homepage = "https://github.com/go-flutter-desktop/hover";
    license = licenses.bsd3;
    maintainers = [ maintainers.ericdallo ];
    platforms = platforms.all;
  };
}
