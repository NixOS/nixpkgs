{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "kerbrute";
  version = "0.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ok/yttRSkCaEdV4aM2670qERjgDBll6Oi3L5TV5YEEA=";
  };

  # This package does not have any tests
  doCheck = false;

  propagatedBuildInputs = with python3.pkgs; [
    impacket
  ];

  installChechPhase = ''
    $out/bin/kerbrute --version
  '';

  meta = {
    homepage = "https://github.com/TarlogicSecurity/kerbrute";
    description = "Kerberos bruteforce utility";
    mainProgram = "kerbrute";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ applePrincess ];
  };
}
