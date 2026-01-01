{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  mock,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "uvcclient";
  version = "0.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kk7ds";
    repo = "uvcclient";
    tag = "v${version}";
    hash = "sha256-V7xIvZ9vIXHPpkEeJZ6QedWk+4ZVNwCzj5ffLyixFz4=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    mock
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    changelog = "https://github.com/uilibs/uvcclient/blob/${src.rev}/CHANGELOG.md";
    description = "Client for Ubiquiti's Unifi Camera NVR";
    mainProgram = "uvc";
    homepage = "https://github.com/kk7ds/uvcclient";
<<<<<<< HEAD
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hexa ];
=======
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
