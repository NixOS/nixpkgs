{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-log-cabinet";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "davidism";
    repo = "sphinxcontrib-log-cabinet";
    rev = "refs/tags/${version}";
    sha256 = "03cxspgqsap9q74sqkdx6r6b4gs4hq6dpvx4j58hm50yfhs06wn1";
  };

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "sphinxcontrib.log_cabinet" ];

  doCheck = false; # no tests

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    homepage = "https://github.com/davidism/sphinxcontrib-log-cabinet";
    description = "Sphinx extension to organize changelogs";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
