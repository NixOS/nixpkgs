{ lib
, buildPythonPackage
, fetchFromGitHub
, isPyPy
}:

buildPythonPackage rec {
  version = "2.0.1";
  pname = "smartypants";
  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "leohemsted";
    repo = "smartypants.py";
    rev = "v${version}";
    sha256 = "sha256-V1rV1B8jVADkS0NhnDkoVz8xxkqrsIHb1mP9m5Z94QI=";
  };

  meta = with lib; {
    description = "Python with the SmartyPants";
    homepage = "https://github.com/leohemsted/smartypants.py";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };

}
