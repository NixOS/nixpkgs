{ stdenv, fetchurl, gettext }:

let version = "2.5.1"; in
stdenv.mkDerivation rec {
  name = "ms-sys-${version}";
 
  src = fetchurl {
    url = "mirror://sourceforge/ms-sys/${name}.tar.gz";
    sha256 = "1vw8yvcqb6iccs4x7rgk09mqrazkalmpxxxsxmvxn32jzdzl5b26";
  };

  buildInputs = [ gettext ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    inherit version;
    homepage = http://ms-sys.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    description = "A program for writing Microsoft compatible boot records";
  };
}
