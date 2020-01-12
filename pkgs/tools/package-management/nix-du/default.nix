{ stdenv, fetchFromGitHub, rustPlatform, nix, boost, graphviz, darwin }:
rustPlatform.buildRustPackage rec {
  pname = "nix-du";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    rev = "v${version}";
    sha256 = "149d60mid29s5alv5m3d7jrhyzc6cj7b6hpiq399gsdwzgxr00wq";
  };
  cargoSha256 = "1r8r5829pyfl0dx4bbq2l3lkrhqpy54xbirxfa6xkp8z8glvipir";
  verifyCargoDeps = true;

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
