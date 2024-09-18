{ lib
, stdenv
, gccStdenv
, autoreconfHook
, autoconf-archive
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
  version = "2.15.6";

  musicVersion = lib.versions.majorMinor version;
  music = stdenv.mkDerivation {
    pname = "7kaa-music";
    version = musicVersion;

    src = fetchurl {
      url = "https://www.7kfans.com/downloads/7kaa-music-${musicVersion}.tar.bz2";
      hash = "sha256-sNdntuJXGaFPXzSpN0SoAi17wkr2YnW+5U38eIaVwcM=";
    };

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';

    meta.license = lib.licenses.unfree;
  };
in
gccStdenv.mkDerivation (finalAttrs: {
  pname = "7kaa";
  inherit version;

  src = fetchFromGitHub {
    owner = "the3dfxdude";
    repo = "7kaa";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kkM+kFQ+tGHS5NrVPeDMRWFQb7waESt8xOLfFGaGdgo=";
  };

  nativeBuildInputs = [ autoreconfHook autoconf-archive pkg-config ];

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
})
