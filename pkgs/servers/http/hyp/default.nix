{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonPackage rec {
  pname = "hyp-server";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JTA5QmLhYFVMb8b2mA+jyVADufvRQzhYN9jaZFmTTtE=";
  };

  meta = with lib; {
    description = "Hyperminimal https server";
    mainProgram = "hyp";
    homepage    = "https://github.com/rnhmjoj/hyp";
    license     = with licenses; [gpl3Plus mit];
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.unix;
  };
}
