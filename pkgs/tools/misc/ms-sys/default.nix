{ stdenv, fetchurl, gettext }:

let version = "2.5.2"; in
stdenv.mkDerivation rec {
  name = "ms-sys-${version}";
 
  src = fetchurl {
    url = "mirror://sourceforge/ms-sys/${name}.tar.gz";
    sha256 = "0c7ld5pglcacnrvy2gzzg1ny1jyknlj9iz1mvadq3hn8ai1d83px";
  };

  buildInputs = [ gettext ];

  enableParallelBuilding = true;

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    inherit version;
    description = "A program for writing Microsoft compatible boot records";
    homepage = http://ms-sys.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nckx ];
  };
}
