{ stdenv
, lib
, fetchurl
, pkg-config
, autoreconfHook
, glib
}:

stdenv.mkDerivation rec {
  pname = "libticonv";
  version = "1.1.5";
  src = fetchurl {
    url = "mirror://sourceforge/tilp/${pname}-${version}.tar.bz2";
    sha256 = "0y080v12bm81wgjm6fnw7q0yg7scphm8hhrls9njcszj7fkscv9i";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  configureFlags = [
    "--enable-iconv"
  ];

  meta = with lib; {
    changelog = "http://lpg.ticalc.org/prj_tilp/news.html";
    description = "This library is part of the TiLP framework";
    homepage = "http://lpg.ticalc.org/prj_tilp/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ siraben luc65r ];
    platforms = with platforms; linux ++ darwin;
  };
}
