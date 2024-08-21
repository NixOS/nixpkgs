{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "token-bucket";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "falconry";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-dazqJRpC8FUHOhgKFzDnIl5CT2L74J2o2Hsm0IQf4Cg=";
  };

  patches = [
    # Replace imp with importlib, https://github.com/falconry/token-bucket/pull/24
    (fetchpatch {
      name = "remove-imp.patch";
      url = "https://github.com/falconry/token-bucket/commit/10a3c9f4de00f4933349f66b4c72b6c96db6e766.patch";
      hash = "sha256-Hk5+i3xzeA3F1kXRaRarWT9mff2lT2WNmTfTZvYzGYI=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Token Bucket Implementation for Python Web Apps";
    homepage = "https://github.com/falconry/token-bucket";
    changelog = "https://github.com/falconry/token-bucket/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
