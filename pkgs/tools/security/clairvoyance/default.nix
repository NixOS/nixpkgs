{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "clairvoyance";
<<<<<<< HEAD
  version = "2.5.3";
=======
  version = "2.0.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "nikitastupin";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-CVXa2HvX7M0cwqnTeZVETg07j324ATQuMNreEgAC2QA=";
=======
    hash = "sha256-Jsb/UjqAppAUz9AGgON6AyVgUdOY6aswjQ9EL939Kro=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
<<<<<<< HEAD
    rich
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = with python3.pkgs; [
    aiounittest
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'asyncio = "^3.4.3"' ""
  '';

  pythonImportsCheck = [
    "clairvoyance"
  ];

  disabledTests = [
    # KeyError
    "test_probe_typename"
  ];

  meta = with lib; {
    description = "Tool to obtain GraphQL API schemas";
    homepage = "https://github.com/nikitastupin/clairvoyance";
<<<<<<< HEAD
    changelog = "https://github.com/nikitastupin/clairvoyance/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
