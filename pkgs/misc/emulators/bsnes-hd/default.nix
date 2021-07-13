{ lib, stdenv, fetchFromGitHub
, pkg-config
, libX11, libXv
, udev
, SDL2
, gtk2, gtksourceview
, alsa-lib, libao, openal, libpulseaudio
, libicns, Cocoa, OpenAL
}:

let
  inherit (lib) optionals;
in
stdenv.mkDerivation {
  pname = "bsnes-hd";
  version = "10.6-beta";

  src = fetchFromGitHub {
    owner = "DerKoun";
    repo = "bsnes-hd";
    rev = "beta_10_6";
    sha256 = "0f3cd89fd0lqskzj98cc1pzmdbscq0psdjckp86w94rbchx7iw4h";
  };

  patches = []
  ++ optionals stdenv.isDarwin [ ./macos-replace-sips-with-png2icns.patch
                                 ./macos-copy-app-to-prefix.patch ];

  nativeBuildInputs = [ pkg-config ]
  ++ optionals stdenv.isDarwin [ libicns ];

  buildInputs = [ SDL2 libao ]
  ++ optionals stdenv.isLinux [ libX11 libXv
                                udev
                                gtk2 gtksourceview
                                alsa-lib openal libpulseaudio ]
  ++ optionals stdenv.isDarwin [ Cocoa OpenAL ];

  buildPhase = ''
    make -j$NIX_BUILD_CORES -C bsnes prefix=$out
  '';

  installPhase = ''
    make -C bsnes install prefix=$out
  '';

  meta = with lib; {
    description = "A fork of bsnes that adds HD video features";
    homepage = "https://github.com/DerKoun/bsnes-hd";
    license = licenses.gpl3;
    maintainers = [ maintainers.stevebob ];
    platforms = platforms.unix;
  };
}
