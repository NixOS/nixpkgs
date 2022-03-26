{ lib
, buildPythonPackage
, fetchPypi
, six
, typing-extensions
, requests
, yarl
, pythonOlder
, fetchFromGitHub
, poetry-core
}:

buildPythonPackage rec {
  pname = "transmission-rpc";
  version = "3.3.0";
  disabled = pythonOlder "3.6";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Trim21";
    repo = "transmission-rpc";
    rev = "v${version}";
    sha256 = "sha256-Ys9trQMCHqxBSaTobWt8WZwi1F8HKTUKaIxvyo6ZPP0=";
  };

  # remove once upstream has tagged version with dumped typing-extensions
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'typing_extensions = ">=3.7.4.2,<4.0.0.0"' 'typing_extensions = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    six
    typing-extensions
    requests
    yarl
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "transmission_rpc" ];

  meta = with lib; {
    description = "Python module that implements the Transmission bittorent client RPC protocol";
    homepage = "https://github.com/Trim21/transmission-rpc";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
