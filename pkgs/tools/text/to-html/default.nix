{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  version = "0.1.5";
  pname = "to-html";

  src = fetchFromGitHub {
    owner = "Aloso";
    repo = "to-html";
    rev = "v${version}";
    hash = "sha256-NNukUzL6S+Vc57OUYt6wcQU7zvCZplQfFWeIB0KEeZo=";
  };

  cargoHash = "sha256-1E6HawenMSRtgOoGcp8m3iTAg8B/Jce84vpo/tFl6Jc=";

  cargoPatches = [ ./cargo-lock.patch ];

  # Requires external resources
  doCheck = false;

  meta = {
    description = "Terminal wrapper for rendering a terminal on a website by converting ANSI escape sequences to HTML.";
    homepage = "https://github.com/Aloso/to-html";
    changelog = "https://github.com/Aloso/to-html/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ icewind1991 ];
  };
}
