{ lib
, stdenv
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "keepwn";
  version = "0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Orange-Cyberdefense";
    repo = "KeePwn";
    rev = "refs/tags/${version}";
    hash = "sha256-haKWuoTtyC9vIise+gznruHEwMIDz1W6euihLLKnSdc=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    chardet
    impacket
    lxml
    pefile
    pykeepass
    python-magic
    termcolor
  ];

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    mv $out/bin/KeePwn $out/bin/$pname
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "keepwn"
  ];

  meta = with lib; {
    description = "Tool to automate KeePass discovery and secret extraction";
    homepage = "https://github.com/Orange-Cyberdefense/KeePwn";
    changelog = "https://github.com/Orange-Cyberdefense/KeePwn/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
