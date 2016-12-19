{ stdenv, fetchFromGitHub, libgcrypt
, pkgconfig, glib, linuxHeaders ? stdenv.cc.libc.linuxHeaders, sqlite }:

stdenv.mkDerivation rec {
  name = "duperemove-${version}";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "markfasheh";
    repo = "duperemove";
    rev = "v${version}";
    sha256 = "1fll0xjg1p3pabgjiddild4ragk9spbdmdzrkq0hv5pxb1qrv7lp";
  };

  buildInputs = [ libgcrypt pkgconfig glib linuxHeaders sqlite ];

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = with stdenv.lib; {
    description = "A simple tool for finding duplicated extents and submitting them for deduplication";
    homepage = https://github.com/markfasheh/duperemove;
    license = licenses.gpl2;
    maintainers = with maintainers; [ bluescreen303 thoughtpolice ];
    platforms = platforms.linux;
  };
}
