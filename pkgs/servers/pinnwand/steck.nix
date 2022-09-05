{ lib
, pkgs
, python3Packages
, nixosTests
}:

python3Packages.buildPythonApplication rec {
  pname = "steck";
  version = "0.7.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1a3l427ibwck9zzzy1sp10hmjgminya08i4r9j4559qzy7lxghs1";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'click>=7.0,<8.0' 'click'
  '';

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
    maintainers = with maintainers; [ hexa ];
  };
}

