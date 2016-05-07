{ stdenv, lib, fetchurl, fetchFromGitHub, cmake, curl, glew, makeWrapper, mesa, SDL2,
  SDL2_image, unzip, wget, zlib, withOpenal ? true, openal ? null }:

assert withOpenal -> openal != null;

stdenv.mkDerivation rec {
  name = "openspades-${version}";
  version = "2016-04-17";

  src = fetchFromGitHub {
    owner = "yvt";
    repo = "openspades";
    rev = "cadc0b6a57fbee05abcaf42d15664502c94b58cf";
    sha256 = "0vyvmgim03q8pcmfa1i0njr4w1lpjq5g3b47f67v9b5c5jcjycwn";
  };

  nativeBuildInputs = 
    with stdenv.lib;
    [ cmake curl glew makeWrapper mesa SDL2 SDL2_image unzip wget zlib ]
    ++ lib.optional withOpenal openal;

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" "-DOPENSPADES_INSTALL_BINARY=bin" "-DOPENSPADES_RESOURCES=NO" ];

  #enableParallelBuilding = true;

  devPack = fetchurl {
    url = "http://yvt.jp/files/programs/osppaks/DevPaks29.zip";
    sha256 = "1fhwxm6wifg0l3ykmiiqa1h4ch5ika2kw2j0v9xnrz24cabsi6cc";
  };

  preBuild = ''
    unzip -u -o $devPack -d Resources/DevPak
  '';

  NIX_CFLAGS_LINK = lib.optional withOpenal "-lopenal";

  meta = with stdenv.lib; {
    description = "A compatible client of Ace of Spades 0.75";
    homepage    = "https://github.com/yvt/openspades/";
    license     = licenses.gpl3;
    platforms   = platforms.linux;
  };
}
