{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "fblog";
<<<<<<< HEAD
  version = "4.4.0";
=======
  version = "4.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "brocode";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-f4iJ9Fp6Rd1jv2ywRCjvFHjbdCGb116NiQ42fvQUE8A=";
  };

  cargoHash = "sha256-dt8OMlqNxd78sDxMPHG6jHEmF4LuFIMSo0BuQDWOM6o=";
=======
    sha256 = "sha256-7+LoCYFI75268Qg2b64I1OOEMZuuxSI9S9Z0/XRLc70=";
  };

  cargoSha256 = "sha256-VMuCSX+FSssha472Lxij2DAYmfmTxLbDWFiRuN9488Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A small command-line JSON log viewer";
    homepage = "https://github.com/brocode/fblog";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}
