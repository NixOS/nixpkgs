{ stdenv, fetchFromGitHub, rustPlatform, nix, boost, graphviz }:
rustPlatform.buildRustPackage rec {
  name = "nix-du-${version}";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    rev = "v${version}";
    sha256 = "1n1qgqjbwbb59xnzgz0dn8h8pckh6yq3crh0w6x2sngijwh678x8";
  };
  cargoSha256 = "1qidbrkdpf4kliyvy2040qi3a67s8mr2r46rjcblr1v2gar0xgs0";

  # switch to true when nix includes https://github.com/NixOS/nix/pull/2223 and 
  # https://github.com/NixOS/nix/pull/2234
  doCheck = false;
  checkInputs = [ graphviz ];

  buildInputs = [
    boost
    nix
  ];

  meta = with stdenv.lib; {
    description = "A tool to determine which gc-roots take space in your nix store";
    homepage = https://github.com/symphorien/nix-du;
    license = licenses.lgpl3;
    maintainers = [ maintainers.symphorien ];
    platforms = platforms.unix;
  };
}
