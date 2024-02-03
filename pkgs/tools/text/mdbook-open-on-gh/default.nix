{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-open-on-gh";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = version;
    hash = "sha256-ZExmOHvQApGZaepOuf3yXYe8NV3FpMtCqCR1KE6q4no=";
  };

  cargoHash = "sha256-WLCcYgkrH5fZvv3LZNEolBQUcTZC2URs6bIgzf4BtWU=";

  meta = with lib; {
    description = "mdbook preprocessor to add a open-on-github link on every page";
    homepage = "https://github.com/badboy/mdbook-open-on-gh";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
