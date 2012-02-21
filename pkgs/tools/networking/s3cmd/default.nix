{ stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
  name = "s3cmd-1.0.1";
  
  src = fetchurl {
    url = "mirror://sourceforge/s3tools/${name}.tar.gz";
    sha256 = "1kmxhilwix5plv3qb49as6jknll3pq5abw948h28jisskkm2cs6p";
  };

  buildInputs = [ pythonPackages.python pythonPackages.wrapPython ];

  installPhase =
    ''
      python setup.py install --prefix=$out
      wrapPythonPrograms
    '';

  meta = {
    homepage = http://s3tools.org/;
    description = "A command-line tool to manipulate Amazon S3 buckets";
  };
}
