{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "treefmt";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "treefmt";
    rev = "v${version}";
    hash = "sha256-icAe54Mv1xpOjUPSk8QDZaMk2ueNvjER6UyJ9uyUL6s=";
  };

  cargoSha256 = "sha256-bpNIGuh74nwEmHPeXtPmsML9vJOb00xkdjK0Nd7esAc=";

  meta = {
    description = "one CLI to format the code tree";
    homepage = "https://github.com/numtide/treefmt";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zimbatm ];
    mainProgram = "treefmt";
  };
}
