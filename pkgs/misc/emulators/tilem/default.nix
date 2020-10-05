{ stdenv
, fetchurl
, lib
, libarchive
, autoreconfHook
, pkgconfig
, glib
, libusb1
, darwin
, acl
, lzma
, bzip2
, gnome2
}:
let
  libticonv = stdenv.mkDerivation rec {
    pname = "libticonv";
    version = "1.1.5";
    src = fetchurl {
      url = "mirror://sourceforge/tilp/${pname}-${version}.tar.bz2";
      sha256 = "0y080v12bm81wgjm6fnw7q0yg7scphm8hhrls9njcszj7fkscv9i";
    };
    nativeBuildInputs = [ autoreconfHook pkgconfig ];
    buildInputs = [ glib ];
    configureFlags = [ "--enable-iconv" ];
  };
  libticables2 = stdenv.mkDerivation rec {
    pname = "libticables2";
    version = "1.3.5";
    src = fetchurl {
      url = "mirror://sourceforge/tilp/${pname}-${version}.tar.bz2";
      sha256 = "08j5di0cgix9vcpdv7b8xhxdjkk9zz7fqfnv3l4apk3jdr8vcvqc";
    };
    nativeBuildInputs = [ autoreconfHook pkgconfig ];
    buildInputs = [ glib libusb1 ];
    configureFlags = [ "--enable-libusb10" ];
  };
  libticalcs2 = stdenv.mkDerivation rec {
    pname = "libticalcs2";
    version = "1.1.9";
    src = fetchurl {
      url = "mirror://sourceforge/tilp/${pname}-${version}.tar.bz2";
      sha256 = "08c9wgrdnyqcs45mx1bjb8riqq81bzfkhgaijxzn96rhpj40fy3n";
    };
    nativeBuildInputs = [ autoreconfHook pkgconfig ];
    buildInputs = [ glib libticables2 libticonv libtifiles2 lzma bzip2 ]
      ++ lib.optionals stdenv.isLinux [ acl ]
      ++ lib.optionals stdenv.isDarwin [ darwin.libobjc ];
  };
  libtifiles2 = stdenv.mkDerivation rec {
    pname = "libtifiles2";
    version = "1.1.7";
    src = fetchurl {
      url = "mirror://sourceforge/tilp/${pname}-${version}.tar.bz2";
      sha256 = "10n9mhlabmaw3ha5ckllxfy6fygs2pmlmj5v6w5v62bvx54kpils";
    };
    nativeBuildInputs = [ autoreconfHook pkgconfig ];
    buildInputs = [ glib libticonv libarchive lzma bzip2 ];
  };
in
stdenv.mkDerivation rec {
  pname = "tilem";
  version = "2.0";
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1ba38xzhp3yf21ip3cgql6jzy49jc34sfnjsl4syxyrd81d269zw";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib gnome2.gtk libticonv libtifiles2 libticables2 libticalcs2 ];
  NIX_CFLAGS_COMPILE = [ "-lm" ];
  meta = with stdenv.lib; {
    homepage = "http://lpg.ticalc.org/prj_tilem/";
    description = "Emulator and debugger for Texas Instruments Z80-based graphing calculators";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
