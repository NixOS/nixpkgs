{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "hunt";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "LyonSyonII";
    repo = "hunt-rs";
    rev = "v${version}";
    sha256 = "sha256-cpqietS/yTI5ONkH4jjIUOVATutd2vj9xmxRbBwmzeI=";
  };

  cargoHash = "sha256-LWZaU+zHbfiogWXW9XGA3iP95u3qqh2LX9LL2lsQPLg=";

  meta = with lib; {
    description = "Simplified Find command made with Rust";
    homepage = "https://github.com/LyonSyonII/hunt-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "hunt";
  };
}
