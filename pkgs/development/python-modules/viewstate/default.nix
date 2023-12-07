{ buildPythonPackage
, fetchFromGitHub
, isPy3k
, lib
, pytest
}:

buildPythonPackage rec {
  pname = "viewstate";
  version = "0.4.3";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "yuvadm";
    repo = pname;
    rev = "v${version}";
    sha256 = "15s0n1lhkz0zwi33waqkkjipal3f7s45rxsj1bw89xpr4dj87qx5";
  };

  nativeCheckInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = {
    description = ".NET viewstate decoder";
    homepage = "https://github.com/yuvadm/viewstate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kamadorueda
    ];
  };
}
