{ stdenv
, buildGoModule
, fetchFromGitHub
, lib
, git
}:
buildGoModule rec {
  pname = "garble";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "burrowers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7HWE5OyeUkXJ66xYpeRbBT966vz8FC1BhXRahzNzcfs=";
  };

  vendorHash = "sha256-su3rl3kINP9rQejs0u2x7JVksEK54xoeOL2GBz08FTM=";

  preBuild = lib.optionalString (!stdenv.isx86_64) ''
    # The test assumex amd64 assembly
    rm testdata/script/asm.txtar
  '';

  # Used for some of the tests.
  nativeCheckInputs = [ git ];

  checkFlags = [
    # See https://github.com/burrowers/garble/issues/609.
    "-skip=TestScript/gogarble"
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  meta = {
    description = "Obfuscate Go code by wrapping the Go toolchain";
    homepage = "https://github.com/burrowers/garble/";
    maintainers = with lib.maintainers; [ davhau ];
    license = lib.licenses.bsd3;
  };
}
