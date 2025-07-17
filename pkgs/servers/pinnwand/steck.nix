{
  lib,
  pkgs,
  python3Packages,
  fetchPypi,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "steck";
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a3l427ibwck9zzzy1sp10hmjgminya08i4r9j4559qzy7lxghs1";
  };

  postPatch = ''
    cat setup.py
    substituteInPlace setup.py \
      --replace 'click>=7.0,<8.0' 'click' \
      --replace 'termcolor>=1.1.0,<2.0.0' 'termcolor'
  '';

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    pkgs.git
    appdirs
    click
    python-magic
    requests
    termcolor
    toml
  ];

  # tests are not in pypi package
  doCheck = false;

  passthru.tests = nixosTests.pinnwand;

  meta = with lib; {
    homepage = "https://github.com/supakeen/steck";
    license = licenses.mit;
    description = "Client for pinnwand pastebin";
    mainProgram = "steck";
    maintainers = with maintainers; [ hexa ];
  };
}
