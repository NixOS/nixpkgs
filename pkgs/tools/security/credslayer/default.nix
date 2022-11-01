{ lib
, fetchFromGitHub
, python3
, wireshark-cli
}:

python3.pkgs.buildPythonApplication rec {
  pname = "credslayer";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "ShellCode33";
    repo = "CredSLayer";
    rev = "v${version}";
    sha256 = "1rbfy0h9c2gra1r2b39kngj3m7g177nmzzs5xy9np8lxixrh17pc";
  };

  propagatedBuildInputs = with python3.pkgs; [
    pyshark
  ];

  checkInputs = with python3.pkgs; [
    wireshark-cli
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/tests.py" ];

  disabledTests = [
    # Requires a telnet setup
    "test_telnet"
    # stdout has all the correct data, but the underlying test code fails
    # functionally everything seems to be intact
    "http_get_auth"
    "test_http_post_auth"
    "test_ntlmssp"
  ];

  pythonImportsCheck = [ "credslayer" ];

  postInstall = ''
    wrapProgram $out/bin/credslayer \
       --prefix PATH : "${lib.makeBinPath [ wireshark-cli ]}"
  '';

  meta = with lib; {
    description = "Extract credentials and other useful info from network captures";
    homepage = "https://github.com/ShellCode33/CredSLayer";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
    # Upstream issue https://github.com/ShellCode33/CredSLayer/issues/16
    # This package works only with pyshark < 0.5
    broken = true;
  };
}
