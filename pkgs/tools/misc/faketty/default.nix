{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "faketty";
  version = "1.0.11";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-HMeJNUF4VT2WdGwAW21GvCp33Bg2HB8NCHv0+3cf74U=";
  };

  cargoSha256 = "sha256-jhSleyhBquU0PxmVPGo1CkuwrzLG7WG5ANPmZ14/ui0=";

  postPatch = ''
    patchShebangs tests/test.sh
  '';

  meta = with lib; {
    description = "A wrapper to execute a command in a pty, even if redirecting the output";
    homepage = "https://github.com/dtolnay/faketty";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
