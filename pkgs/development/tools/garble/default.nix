{ stdenv
, buildGoModule
, fetchFromGitHub
, lib
, git
}:
buildGoModule rec {
  pname = "garble";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "burrowers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-T6iUhfBcHlz9oUuovwU4ljHh4y6PRd3sRhwG6RwuspM=";
  };

  vendorSha256 = "sha256-lGU9jbeOM8tSYZGIqQhH5I2RlBGnqrA6JUQpuHrLwKU=";

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
