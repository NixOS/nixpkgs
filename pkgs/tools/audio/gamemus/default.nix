{ stdenv, fetchFromGitHub, autoreconfHook, boost, callPackage
, pkgconfig, xmlto, docbook_xsl, portaudio }:

let
  libgamecommon = callPackage ./libgamecommon.nix {};
in stdenv.mkDerivation rec {
  name = "gamemus-${version}";
  version = "2017-12-03";

  src = fetchFromGitHub {
    owner = "Malvineous";
    repo = "libgamemusic";
    rev = "ddf1d4849d156cbc8c457fb8283dba9169d8153c";
    sha256 = "0r3h3zvgwmfj5lh68dqsixrkvfb5hja8v0k07hpzj4372iygmgac";
  };

  doCheck = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook pkgconfig xmlto docbook_xsl libgamecommon
  ];
  buildInputs = [ boost portaudio ];

  configureFlags = [
    "--with-boost-libdir=${boost}/lib"
    "--disable-shared"
  ];

  meta = with stdenv.lib; {
    description = "Utility to read, write and convert DOS game music files";
    homepage = http://www.shikadi.net/camoto/manpage/gamemus;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}
