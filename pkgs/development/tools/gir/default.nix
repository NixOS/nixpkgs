{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "gir";
  version = "unstable-2021-05-05";

  src = fetchFromGitHub {
    owner = "gtk-rs";
    repo = "gir";
    rev = "c148542ce89b0bf7cbb9f5ef4179c96a45d022df";
    sha256 = "0vy366ipwnn0cpp14l1v5g3dpnsr3hd8mjp3333lp0946igfqsy5";
    leaveDotGit = true; # required for build.rs
  };

  cargoSha256 = "11as1v88zf0f7l2ngllg5zqycvd05nb4vrsyl1dlarjvbq7fhvv8";

  meta = with lib; {
    description = "Tool to generate rust bindings and user API for glib-based libraries";
    homepage = "https://github.com/gtk-rs/gir/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ekleog ];
  };
}
