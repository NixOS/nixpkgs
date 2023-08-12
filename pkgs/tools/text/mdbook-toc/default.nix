{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-toc";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = version;
    sha256 = "sha256-Z3ZspXD7M3VVi70+dRz7NhO6msw5htmPRX6VzhA9NPY=";
  };

  cargoHash = "sha256-5EC9xfjSg0sIkZ2fIkX3SrwL0wzBfpIObFQpkMRj6oM=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add inline Table of Contents support";
    homepage = "https://github.com/badboy/mdbook-toc";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

