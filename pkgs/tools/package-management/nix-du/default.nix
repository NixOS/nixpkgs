{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, nix
, nlohmann_json
, boost
, graphviz
, Security
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-du";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    rev = "v${version}";
    sha256 = "0v6hixj81aa6g3sddny46i0yqaaqv6krp5xadj0xz1g77cb8xy2w";
  };

  cargoSha256 = "11jaks6adsvrvxlqqw3glvn4ff7xh9j35ayfrl89rb4achvqp7xn";

  doCheck = true;
  checkInputs = [ nix graphviz ];

  buildInputs = [
    boost
    nix
    nlohmann_json
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
