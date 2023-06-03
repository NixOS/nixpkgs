{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-toc";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = version;
    sha256 = "sha256-7JpMBQqglLn33HwMBuIR5Hc0ISmzLPjQXGJVRwwl4OU=";
  };

  cargoSha256 = "sha256-Vj9DSjJtkexKly8IWlGEQkVrjSHcK1/2i+2g2Ht0eUo=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add inline Table of Contents support";
    homepage = "https://github.com/badboy/mdbook-toc";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

