{ stdenv, fetchFromGitHub, rustPlatform, nix, boost, graphviz, darwin }:
rustPlatform.buildRustPackage rec {
  name = "nix-du-${version}";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    rev = "v${version}";
    sha256 = "1x6qpivxbn94034jfdxb97xi97fhcdv2z7llq2ccfc80mgd0gz8l";
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
