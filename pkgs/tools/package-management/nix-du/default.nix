{ stdenv, fetchFromGitHub, rustPlatform, nix, boost, graphviz }:
rustPlatform.buildRustPackage rec {
  name = "nix-du-${version}";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    rev = "v${version}";
    sha256 = "0kxacn5qw21pp4zl6wr9wyb2mm2nlnp6mla3m5p9dm7vrm1fd1x9";
  };
  cargoSha256 = "04c48lzi7hny3nq4ffdpvsr4dxbi32faka163fp1yc9953zdw9az";

  doCheck = !stdenv.isDarwin;
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
