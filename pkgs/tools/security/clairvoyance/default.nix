{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "clairvoyance";
  version = "2.0.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "nikitastupin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Jsb/UjqAppAUz9AGgON6AyVgUdOY6aswjQ9EL939Kro=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
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
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
