{ stdenv
, buildGoModule
, fetchFromGitHub
, lib
, git
}:
buildGoModule rec {
  pname = "garble";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "burrowers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QQRnnH/lbleZYkmHj4XUj2uMB9h/mwolhqWfaWMk2ys=";
  };

  vendorSha256 = "sha256-Xax8KfNcFCLKqcLBNtRUNaneVCW4eUMFe4Ml+D4wLNA=";

  # Used for some of the tests.
  checkInputs = [git];

  preBuild = lib.optionalString (!stdenv.isx86_64) ''
    # The test assumex amd64 assembly
    rm testdata/scripts/asm.txt
  '';

  meta = {
    description = "Obfuscate Go code by wrapping the Go toolchain";
    homepage = "https://github.com/burrowers/garble/";
    maintainers = with lib.maintainers; [ davhau ];
    license = lib.licenses.bsd3;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/garble.x86_64-darwin
  };
}
