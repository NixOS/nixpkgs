{ lib, stdenv, fetchFromGitHub, rustPlatform, nix, boost, graphviz, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "nix-du";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    rev = "v${version}";
    sha256 = "0h8ya0nn65hbyi3ssmrjarfxadx2sa61sspjlrln8knk7ppxk3mq";
  };

  cargoSha256 = "07qgvnwk77xg9k2g4cwlwafczjs8yf0sbb1h61c6hkicdhsb76g0";

  doCheck = true;
  checkInputs = [ nix graphviz ];

  buildInputs = [
    boost
    nix
  ] ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  meta = with lib; {
    description = "A tool to determine which gc-roots take space in your nix store";
    homepage = "https://github.com/symphorien/nix-du";
    license = licenses.lgpl3;
    maintainers = [ maintainers.symphorien ];
    platforms = platforms.unix;
  };
}
