{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "strenum";
<<<<<<< HEAD
  version = "0.4.15";
=======
  version = "0.4.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "irgeek";
    repo = "StrEnum";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-LrDLIWiV/zIbl7CwKh7DAy4LoLyY7+hfUu8nqduclnA=";
=======
    hash = "sha256-OkNV4kUXGgYPGuyylGOtAr0e0spgZQ1MrftKKL2HmV8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
    substituteInPlace pytest.ini \
      --replace " --cov=strenum --cov-report term-missing --black --pylint" ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "strenum"
  ];

  meta = with lib; {
    description = "MOdule for enum that inherits from str";
    homepage = "https://github.com/irgeek/StrEnum";
    changelog = "https://github.com/irgeek/StrEnum/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
