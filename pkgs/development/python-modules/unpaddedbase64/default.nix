{ stdenv
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "unpaddedbase64";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "python-${pname}";
    rev = "refs/tags/v${version}";
    sha256 = "0if3fjfxga0bwdq47v77fs9hrcqpmwdxry2i2a7pdqsp95258nxd";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/matrix-org/python-unpaddedbase64";
    description = "Unpadded Base64";
    license = licenses.asl20;
  };

}
