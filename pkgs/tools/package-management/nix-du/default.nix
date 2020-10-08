{ stdenv, fetchFromGitHub, rustPlatform, nix, boost, graphviz, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "nix-du";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    rev = "v${version}";
    sha256 = "0h8ya0nn65hbyi3ssmrjarfxadx2sa61sspjlrln8knk7ppxk3mq";
  };

  cargoSha256 = "0d86bn6myr29bwrzw3ihnzg1yij673s80bm1l8srk2k2szyfwwh5";

  doCheck = true;
  checkInputs = [ nix graphviz ];

  buildInputs = [
    boost
    nix
  ] ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  meta = with stdenv.lib; {
    description = "A tool to determine which gc-roots take space in your nix store";
    homepage = "https://github.com/symphorien/nix-du";
    license = licenses.lgpl3;
    maintainers = [ maintainers.symphorien ];
    platforms = platforms.unix;
  };
}
