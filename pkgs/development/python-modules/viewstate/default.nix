{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "viewstate";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yuvadm";
    repo = "viewstate";
    tag = "v${version}";
    sha256 = "sha256-fvqz03rKkA2WVVXU74eo0otnuRseE83cv6pw3rMso34=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = ".NET viewstate decoder";
    homepage = "https://github.com/yuvadm/viewstate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
