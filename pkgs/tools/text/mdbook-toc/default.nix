{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-toc";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = version;
    sha256 = "sha256-3lAi9ZNtwhA2OtIR4tN2wiztp3pnRxtaGG0MwGEk0u0=";
  };

  cargoHash = "sha256-l3ETQ/ARBZmU1wMCK6F/4g6tlxHsEV9D5LO1wue1Jps=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add inline Table of Contents support";
    homepage = "https://github.com/badboy/mdbook-toc";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

