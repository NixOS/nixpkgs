{ lib, stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "volatility";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "volatilityfoundation";
    repo = pname;
    rev = version;
    sha256 = "1v92allp3cv3akk71kljcwxr27h1k067dsq7j9h8jnlwk9jxh6rf";
  };

  doCheck = false;

  propagatedBuildInputs = [ pythonPackages.pycrypto pythonPackages.distorm3 ];

  meta = with lib; {
    homepage = "https://www.volatilityfoundation.org/";
    description = "Advanced memory forensics framework";
    maintainers = with maintainers; [ bosu ];
    license = lib.licenses.gpl2Plus;
  };
}
