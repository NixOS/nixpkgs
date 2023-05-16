{ lib
, stdenv
, gccStdenv
, autoreconfHook
<<<<<<< HEAD
, autoconf-archive
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pkg-config
, fetchurl
, fetchFromGitHub
, openal
, libtool
, enet
, SDL2
, curl
, gettext
, libiconv
}:

let
  pname = "7kaa";
<<<<<<< HEAD
  version = "2.15.5";

  musicVersion = lib.versions.majorMinor version;
  music = stdenv.mkDerivation {
    pname = "7kaa-music";
    version = musicVersion;

    src = fetchurl {
      url = "https://www.7kfans.com/downloads/7kaa-music-${musicVersion}.tar.bz2";
      hash = "sha256-sNdntuJXGaFPXzSpN0SoAi17wkr2YnW+5U38eIaVwcM=";
=======
  version = "2.15.4p1";

  music = stdenv.mkDerivation {
    pname = "7kaa-music";
    version = lib.versions.majorMinor version;

    src = fetchurl {
      url = "https://www.7kfans.com/downloads/7kaa-music-${lib.versions.majorMinor version}.tar.bz2";
      sha256 = "sha256-sNdntuJXGaFPXzSpN0SoAi17wkr2YnW+5U38eIaVwcM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';

    meta.license = lib.licenses.unfree;
<<<<<<< HEAD
  };
in
=======

  };

in

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
gccStdenv.mkDerivation rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "the3dfxdude";
    repo = pname;
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-Z6TsR6L6vwpzoKTj6xJ6HKy4DxcUBWmYBFi/a9pQBD8=";
  };

  nativeBuildInputs = [ autoreconfHook autoconf-archive pkg-config ];

=======
    rev = "9db2a43e1baee25a44b7aa7e9cedde9a107ed34b";
    sha256 = "sha256-OAKaRuPP0/n8pO3wIUvGKs6n+U+EmZXUTywXYDAan1o=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [ openal enet SDL2 curl gettext libiconv ];

  preAutoreconf = ''
    autoupdate
  '';

  hardeningDisable = lib.optionals (stdenv.isAarch64 && stdenv.isDarwin) [ "stackprotector" ];

  postInstall = ''
    mkdir $out/share/7kaa/MUSIC
    cp -R ${music}/MUSIC $out/share/7kaa/
    cp ${music}/COPYING-Music.txt $out/share/7kaa/MUSIC
    cp ${music}/COPYING-Music.txt $out/share/doc/7kaa
  '';

  # Multiplayer is auto-disabled for non-x86 system

  meta = with lib; {
    homepage = "https://www.7kfans.com";
    description = "GPL release of the Seven Kingdoms with multiplayer (available only on x86 platforms)";
    license = licenses.gpl2Only;
    platforms = platforms.x86_64 ++ platforms.aarch64;
    maintainers = with maintainers; [ _1000101 ];
  };
}
