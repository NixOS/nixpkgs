{ lib, rustPlatform, fetchFromGitHub, nix-update-script }:
rustPlatform.buildRustPackage rec {
  pname = "prosemd-lsp";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kitten";
    repo = pname;
    rev = "v${version}";
    sha256 = "FnAf7+1tDho0Fbhsd6XXxnNADVwEwY13rXjrUbGqLdQ=";
  };

  cargoSha256 = "1KE84o/KDkDMwlxqeDQmniBL6mDE1RSWG5J8nTvBwa4=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description =
      "An experimental proofreading and linting language server for markdown files";
    homepage = "https://github.com/kitten/prosemd-lsp";
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = [ maintainers.caarlos0 ];
  };
}
