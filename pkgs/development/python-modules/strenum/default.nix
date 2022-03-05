{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "strenum";
  version = "0.4.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "irgeek";
    repo = "StrEnum";
    rev = "v${version}";
    hash = "sha256-ktsPROIv/BbPinZfrBknI4c/WwRYGhWgmw209Hfg8EQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
    substituteInPlace pytest.ini \
      --replace " --cov=strenum --cov-report term-missing --black --pylint" ""
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "strenum"
  ];

  meta = with lib; {
    description = "MOdule for enum that inherits from str";
    homepage = "https://github.com/irgeek/StrEnum";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
