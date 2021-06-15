{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
}:

buildPythonPackage rec {
  pname = "sgmllib3k";
  version = "1.0.0";
  disabled = isPy27;

  # fetchFromGitHub instead of fetchPypi to run tests.
  src = fetchFromGitHub {
    owner = "hsoft";
    repo = "sgmllib";
    rev = "799964676f35349ca2dd04503e34c2b3ad522c0d";
    sha256 = "0bzf6pv85dzfxfysm6zbj8m40hp0xzr9h8qlk4hp3nmy88rznqvr";
  };

  meta = with lib; {
    homepage = "https://pypi.org/project/sgmllib3k/";
    description = "Python 3 port of sgmllib";
    license = licenses.bsd2;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
