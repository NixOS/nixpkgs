{ stdenv, fetchFromGitHub, rustPlatform, nix, boost, graphviz, darwin }:
rustPlatform.buildRustPackage rec {
  pname = "nix-du";
  version = "unstable-2019-07-15";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    rev = "e6e927c15e75f7c2e63f7f3c181dc6b257f6fd9e";
    sha256 = "08jyp078h9jpb9qfqg5mdbq29rl8a006n94hqk3yk6gv1s57cfic";
  };
  cargoSha256 = "071gbhxbvnwi7n3zpy7bmlprzir0sl0f0pb191xg2ynw678prd7v";

  doCheck = true;
  checkInputs = [ graphviz ];

  buildInputs = [
    boost
    nix
  ] ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  meta = with stdenv.lib; {
    description = "A tool to determine which gc-roots take space in your nix store";
    homepage = https://github.com/symphorien/nix-du;
    license = licenses.lgpl3;
    maintainers = [ maintainers.symphorien ];
    platforms = platforms.unix;
  };
}
