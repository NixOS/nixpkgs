{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "unidic-lite";
  version = "1.0.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-251Fctn91NAKl5SdSwdB7EgO4Fp+fi4y9UdQDa4nskU=";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "unidic_lite" ];

  meta = with lib; {
    description = "Small version of UniDic";
    homepage = "https://github.com/polm/unidic-lite";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
