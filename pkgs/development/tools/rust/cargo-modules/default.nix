{ lib, rustPlatform, fetchFromGitHub, stdenv, CoreFoundation, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-modules";
  version = "0.5.10";

  src = fetchFromGitHub {
    owner = "regexident";
    repo = pname;
    rev = version;
    sha256 = "sha256-tzJBbDo3xYZ/db8Oz8MJqWtRyljxWMNJu071zYq7d7A=";
  };

  cargoSha256 = "sha256-LO0Y7X498WwmZ7zl+AUBteLJeo65c0VUIAvjbW4ZDqw=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    CoreServices
  ];

  meta = with lib; {
    description = "A cargo plugin for showing a tree-like overview of a crate's modules";
    homepage = "https://github.com/regexident/cargo-modules";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ figsoda rvarago ];
  };
}
