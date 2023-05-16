<<<<<<< HEAD
{ lib, python3, fetchPypi }:
=======
{ lib, python3 }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3.pkgs.buildPythonApplication rec {
  pname = "kerbrute";
  version = "0.0.2";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3.pkgs.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ applePrincess ];
  };
}
