{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dpkt,
  pyyaml,
  pythonOlder,
  pytestCheckHook,
}:
buildPythonPackage {
  pname = "ts1-signatures";
  version = "0-unstable-2024-08-10";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "yifeikong";
    repo = "th1";
    rev = "efa682bd37c668ae00d2225deb753e01f6cd1406";
    hash = "sha256-fz5EFPO5UPPbFnqe4wE1y2lIROPByse9awyBa49o8ZE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dpkt
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_nghttpd_log_parsing" # Attempts to load things from logs/ which it cannot find for some reason.
  ];

  meta = {
    description = "TLS and HTTP signature and fingerprint library";
    homepage = "https://github.com/yifeikong/th1";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ggg ];
  };
}
