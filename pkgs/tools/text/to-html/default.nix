{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  version = "0.1.4";
  pname = "to-html";

  src = fetchFromGitHub {
    owner = "Aloso";
    repo = "to-html";
    rev = "v${version}";
    hash = "sha256-zkTBjsMFhRz7lVRh8i+XkaJ/qWmTAMPnkH5aDhbHf8U=";
  };

  cargoHash = "sha256-hXc+lB3DKnRZkp1U5wW/vPKSZ0c1UknQCAxDfE7Eubg=";

  # Requires external resources
  doCheck = false;

  meta = {
    description = "Terminal wrapper for rendering a terminal on a website by converting ANSI escape sequences to HTML";
    homepage = "https://github.com/Aloso/to-html";
    changelog = "https://github.com/Aloso/to-html/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ icewind1991 ];
  };
}
