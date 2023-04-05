{ lib, rustPlatform, fetchFromGitHub, boost, nix, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "nix-doc";
  version = "0.5.8";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "lf-";
    repo = "nix-doc";
    sha256 = "sha256-murez5uHLv1YXIaDDaFXCDPPggK1GAXjaSmZJhlqN80=";
  };

  doCheck = true;
  buildInputs = [ boost nix ];

  nativeBuildInputs = [ pkg-config nix ];

  cargoSha256 = "sha256-+6I6+LZs84OcyebAIg/9KeAxV1UdK9IgaT7UsPJ5rWQ=";

  meta = with lib; {
    description = "An interactive Nix documentation tool";
    longDescription = "An interactive Nix documentation tool providing a CLI for function search, a Nix plugin for docs in the REPL, and a ctags implementation for Nix script";
    homepage = "https://github.com/lf-/nix-doc";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.lf- ];
    platforms = platforms.unix;
  };
}
