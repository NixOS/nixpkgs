{ stdenv, fetchFromGitHub, autoreconfHook
, intltool, pkgconfig, sqlite, libpinyin, db
, ibus, glib, gtk3, python3
}:

stdenv.mkDerivation rec {
  name = "ibus-libpinyin-${version}";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner  = "libpinyin";
    repo   = "ibus-libpinyin";
    rev    = version;
    sha256 = "1d85kzlhav0ay798i88yqyrjbkv3y7w2aiadpmcjgscyd5ccsnnz";
  };

  buildInputs = [ ibus glib sqlite libpinyin python3 gtk3 db ];
  nativeBuildInputs = [ autoreconfHook intltool pkgconfig python3.pkgs.wrapPython ];

  postAutoreconf = ''
    intltoolize
  '';

  postFixup = "wrapPythonPrograms";

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "IBus interface to the libpinyin input method";
    license      = licenses.gpl2;
    maintainers  = with maintainers; [ ericsagnes ];
    platforms    = platforms.linux;
  };
}
