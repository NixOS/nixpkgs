{ lib
, stdenv
, gccStdenv
, autoreconfHook
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

  name = "7kaa";
  versionMajor = "2.15";
  versionMinor = "4p1";

  music = stdenv.mkDerivation rec {
    pname = "${name}-music";
    version = "${versionMajor}";

    src = fetchurl {
      url = "https://www.7kfans.com/downloads/${name}-music-${versionMajor}.tar.bz2";
      sha256 = "sha256-sNdntuJXGaFPXzSpN0SoAi17wkr2YnW+5U38eIaVwcM=";
    };

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';

    meta.license = lib.licenses.unfree;

  };

in

gccStdenv.mkDerivation rec {
  pname = "${name}";
  version = "v${versionMajor}.${versionMinor}";

  src = fetchFromGitHub {
    owner = "the3dfxdude";
    repo = pname;
    rev = "9db2a43e1baee25a44b7aa7e9cedde9a107ed34b";
    sha256 = "sha256-OAKaRuPP0/n8pO3wIUvGKs6n+U+EmZXUTywXYDAan1o=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
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
