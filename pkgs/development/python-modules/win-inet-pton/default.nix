{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:
buildPythonPackage {
  pname = "win-inet-pton";
  version = "0-unstable-2019-02-19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hickeroar";
    repo = "win_inet_pton";
    rev = "57e35581c4b2c25650d931fe6d4b6c80cbb7fd27";
    hash = "sha256-dxrzQ6Nj4pR5WNc+RVDlA8ba7mvfBW5qB4i6Ai1gM2c=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = ["win_inet_pton"];

  meta = with lib; {
    description = "Native inet_pton and inet_ntop implementation for Python on Windows";
    homepage = "https://github.com/hickeroar/win_inet_pton";
    license = licenses.publicDomain;
    maintainers = with maintainers; [vinnymeller];
  };
}
