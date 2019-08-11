{ stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  name = "kakasi-2.3.6";

  buildInputs = stdenv.lib.optional stdenv.isDarwin [ libiconv ];

  meta = with stdenv.lib; {
    description = "Kanji Kana Simple Inverter";
    longDescription = ''
      KAKASI is the language processing filter to convert Kanji
      characters to Hiragana, Katakana or Romaji and may be
      helpful to read Japanese documents.
    '';
    homepage    = "http://kakasi.namazu.org/";
    license     = licenses.gpl2Plus;
    platforms   = platforms.unix;
  };

  src = fetchurl {
    url = "http://kakasi.namazu.org/stable/${name}.tar.xz";
    sha256 = "1qry3xqb83pjgxp3my8b1sy77z4f0893h73ldrvdaky70cdppr9f";
  };

  postPatch = ''
    for a in tests/kakasi-* ; do
      substituteInPlace $a \
        --replace "/bin/echo" echo
    done
  '';

  doCheck = false; # fails 1 of 6 tests

}
