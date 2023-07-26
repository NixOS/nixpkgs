{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-toc";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = version;
    sha256 = "sha256-F0dIqtDEOVUXlWhmXKPOaJTEuA3Tl3h0vaEu7VsBo7s=";
  };

  cargoHash = "sha256-gbBX6Hj+271BA9FWmkZdyR0tMP2Lny7UgW0o+kZe9bU=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add inline Table of Contents support";
    homepage = "https://github.com/badboy/mdbook-toc";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

