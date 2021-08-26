{ lib, buildPythonPackage, fetchPypi, isPy3k, nose
, lxml
, requests
, pyparsing
}:
buildPythonPackage rec {
  pname = "twill";
  version = "3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01770eddb34f5fe6ee59992b84619968885d359ad3d6d9191e8ba8eec93482aa";
  };

  checkInputs = [ nose ];

  propagatedBuildInputs = [
    lxml
    requests
    pyparsing
  ];

  doCheck = false; # pypi package comes without tests, other homepage does not provide all verisons

  meta = with lib; {
    homepage = "https://twill-tools.github.io/twill/";
    description = "A simple scripting language for Web browsing";
    license     = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
