{ stdenv
, fetchurl
, lib
, autoreconfHook
, pkg-config
, glib
, darwin
, acl
, gnome2
, libticonv
, libtifiles2
, libticables2
}:
let
  libticalcs2 = stdenv.mkDerivation rec {
    pname = "libticalcs2";
    version = "1.1.9";
    src = fetchurl {
      url = "mirror://sourceforge/tilp/${pname}-${version}.tar.bz2";
      sha256 = "08c9wgrdnyqcs45mx1bjb8riqq81bzfkhgaijxzn96rhpj40fy3n";
    };
    nativeBuildInputs = [ autoreconfHook pkg-config ];
    buildInputs = [ glib libticables2 libticonv libtifiles2 lzma bzip2 ]
      ++ lib.optionals stdenv.isLinux [ acl ]
      ++ lib.optionals stdenv.isDarwin [ darwin.libobjc ];
  };
in

stdenv.mkDerivation rec {
  pname = "tilem";
  version = "2.0";
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1ba38xzhp3yf21ip3cgql6jzy49jc34sfnjsl4syxyrd81d269zw";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib gnome2.gtk libticonv libtifiles2 libticables2 libticalcs2 ];
  NIX_CFLAGS_COMPILE = [ "-lm" ];
  meta = with lib; {
    homepage = "http://lpg.ticalc.org/prj_tilem/";
    description = "Emulator and debugger for Texas Instruments Z80-based graphing calculators";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ siraben luc65r ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
