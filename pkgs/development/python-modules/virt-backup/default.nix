{ lib
, appdirs
, arrow
, buildPythonPackage
, deepdiff
, fetchFromGitHub
, fetchpatch
, libvirt
, lxml
, packaging
, pytest-mock
, pytestCheckHook
, pythonOlder
, pyyaml
, zstandard
}:

buildPythonPackage rec {
  pname = "virt-backup";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "aruhier";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YZQi0OLyZa4pD4aLCkoHVW7s+bWMD/9tMPwChL0+U8U=";
  };

  disabled = pythonOlder "3.5";

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-cov", ' "" \
      --replace "'pytest-runner', " ""
  '';

  checkInputs = [
    deepdiff
    pytest-mock
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    appdirs
    arrow
    libvirt
    lxml
    packaging
    pyyaml
    zstandard
  ];

  pythonImportsCheck = [ "virt_backup" ];

  disabledTestPaths = [
    "tests/test_unsupported.py"
  ];

  meta = with lib; {
    description = "Do external backup of your KVM guests, managed by libvirt, using the BlockCommit feature";
    homepage = "https://github.com/aruhier/virt-backup";
    maintainers = with maintainers; [ rhoriguchi ];
    license = licenses.bsd2;
  };
}
