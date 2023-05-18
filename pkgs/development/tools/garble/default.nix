{ stdenv
, buildGoModule
, fetchFromGitHub
, lib
, git
}:
buildGoModule rec {
  pname = "garble";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "burrowers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-f7coWG1CS4UL8GGqwADx5CvIk2sPONPlWW+JgRhFsb8=";
  };

  vendorSha256 = "sha256-SOdIlu0QrQokl9j9Ff594+1K6twU1mCuECFQaVKaPV4=";

  # Used for some of the tests.
  nativeCheckInputs = [git];

  preBuild = lib.optionalString (!stdenv.isx86_64) ''
    # The test assumex amd64 assembly
    rm testdata/script/asm.txtar
  '';

  meta = {
    description = "Obfuscate Go code by wrapping the Go toolchain";
    homepage = "https://github.com/burrowers/garble/";
    maintainers = with lib.maintainers; [ davhau ];
    license = lib.licenses.bsd3;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/garble.x86_64-darwin
  };
}
