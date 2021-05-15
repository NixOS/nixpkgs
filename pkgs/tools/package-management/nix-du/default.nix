{ lib, stdenv, fetchFromGitHub, rustPlatform, nix, boost, graphviz, Security, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "nix-du";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    rev = "v${version}";
    sha256 = "0iwlprjbphwsrxdhgsxa8ja73snsyh0rdxrpsf1ygid2ky5vc83f";
  };

  cargoSha256 = "19fwkw9iswzkhqgfq7pmcabqmq5c7vvirwaxbfjshkwcgn47rgjl";

  doCheck = true;
  checkInputs = [ nix graphviz ];

  buildInputs = [
    boost
    nix
  ] ++ lib.optionals stdenv.isDarwin [ Security ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "A tool to determine which gc-roots take space in your nix store";
    homepage = "https://github.com/symphorien/nix-du";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.symphorien ];
    platforms = platforms.unix;
  };
}
