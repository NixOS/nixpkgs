{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "clairvoyance";
  version = "2.0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "nikitastupin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-b69a3UTRt5axTSjLcEYkqGe7bFlQKCiMzoNtw91HCyI=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
  ];

  checkInputs = with python3.pkgs; [
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
