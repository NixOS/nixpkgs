{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "diffr";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "mookid";
    repo = pname;
    rev = "v${version}";
    sha256 = "18ks5g4bx6iz9hdjxmi6a41ncxpb1hnsscdlddp2gr40k3vgd0pa";
  };

  cargoSha256 = "0pn3vqv13n29h8069a38306vjlzlxf1m08ldv7lpzgqxhl8an00r";

  buildInputs = (lib.optional stdenv.isDarwin Security);

  preCheck = ''
    export DIFFR_TESTS_BINARY_PATH=$releaseDir/diffr
  '';

  meta = with lib; {
    description = "Yet another diff highlighting tool";
    homepage = "https://github.com/mookid/diffr";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ davidtwco ];
  };
}
