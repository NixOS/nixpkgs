{ stdenv, fetchFromGitHub, rustPlatform, nix, boost, graphviz }:
rustPlatform.buildRustPackage rec {
  name = "nix-du-${version}";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    rev = "v${version}";
    sha256 = "1y7ifr4c3v1494swh6akvna0d0rxjy9jw3mw2wdd6vj1xphvmimq";
  };
  cargoSha256 = "0qq7a6ncxnbjvnmly99awqrk9f3z9b55ifil7b0bn5yhk4h9sa6y";

  doCheck = true;
  checkInputs = [ graphviz ];
  nativeBuildInputs = [] ++ stdenv.lib.optionals doCheck checkInputs;

  buildInputs = [
    boost
    nix
  ];

  meta = with stdenv.lib; {
    description = "A tool to determine which gc-roots take space in your nix store";
    homepage = https://github.com/symphorien/nix-du;
    license = licenses.lgpl3;
    maintainers = [ maintainers.symphorien ];
    platforms = platforms.all;
  };
}
