{ stdenv
, buildPythonPackage
, fetchFromGitHub
, cmake
}:

buildPythonPackage {
  pname = "tlsh";
  version = "3.19.1";

  src = fetchFromGitHub {
    owner = "trendmicro";
    repo = "tlsh";
    rev = version;
    sha256 = "1mbkyxxq83y9pr6gnn4f4jfpbv0lbbmihnrszcwg11cjzi7j70b5";
  };

  nativeBuildInputs = [ cmake ];

  # no test data
  doCheck = false;

  postConfigure = ''
    cd ../py_ext
  '';

  meta = with stdenv.lib; {
    description = "Trend Micro Locality Sensitive Hash";
    homepage = "https://github.com/trendmicro/tlsh";
    license = licenses.asl20;
    platforms = platforms.unix;
  };

}
