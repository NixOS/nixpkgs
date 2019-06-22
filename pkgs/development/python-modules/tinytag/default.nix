{ stdenv, fetchPypi, substituteAll, python3Packages }:

python3Packages.buildPythonPackage rec {
  version = "1.2.2";
  pname = "tinytag";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256:0r2pazrqq9lxy3an7vvafc6whglnawx2mi8x75gnrr56a02xpr8h";
  };

  propagatedBuildInputs = with python3Packages; [
    twine
  ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Read music meta data and length of MP3, OGG, OPUS, MP4, M4A, FLAC, WMA and Wave files with python 2 or 3";
    homepage = "https://github.com/devsnd/tinytag";
    license = licenses.mit;
    maintainers = [ maintainers.deepfire ];
  };
}
