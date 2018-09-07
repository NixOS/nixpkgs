{ stdenv, fetchFromGitHub, libgcrypt
, pkgconfig, glib, linuxHeaders ? stdenv.cc.libc.linuxHeaders, sqlite }:

stdenv.mkDerivation rec {
  name = "duperemove-${version}";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "markfasheh";
    repo = "duperemove";
    rev = "v${version}";
    sha256 = "09bwpsvnppl9bm2l5pym5673x04ah3hddb0xip61gdq8ws3ri5yj";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libgcrypt glib linuxHeaders sqlite ];

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = with stdenv.lib; {
    description = "A simple tool for finding duplicated extents and submitting them for deduplication";
    homepage = https://github.com/markfasheh/duperemove;
    license = licenses.gpl2;
    maintainers = with maintainers; [ bluescreen303 thoughtpolice ];
    platforms = platforms.linux;
  };
}
