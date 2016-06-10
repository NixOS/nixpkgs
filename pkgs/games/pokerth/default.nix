{ stdenv, fetchurl, qt4, protobuf, boost, zlib, curl, libgcrypt, gsasl, SDL,
sqlite, tinyxml }:

stdenv.mkDerivation rec {
    version = "1.1.1";
    name = "pokerth-${version}";

    src = fetchurl {
        url = "http://downloads.sourceforge.net/project/pokerth/pokerth/1.1/PokerTH-${version}-src.tar.bz2";
        sha256 = "123k6nji84nl6a6qbfhdnx1hsjmisd8jkvl9dpyr5prggn4d7rmg";
    };

    buildInputs = [ qt4 protobuf boost zlib curl libgcrypt gsasl SDL sqlite tinyxml ];

    configurePhase = ''
        export BOOST_LIBS_PATH=${boost}/lib/
        qmake PREFIX=$out pokerth.pro
    '';

    meta = with stdenv.lib; {
        description = "Open Source Poker Game";
# homepage = http://xmoto.tuxfamily.org;
        maintainers = with maintainers; [ matthiasbeyer ];
        platforms = platforms.linux;
    };
}
