{ lib, rustPlatform, fetchCrate, stdenv, CoreFoundation, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-modules";
  version = "0.5.14";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-urbyWNbmj2qEO4JJ/waRXGRJ9L5KgwsRB5Wh9yib8zc=";
  };

  cargoSha256 = "sha256-3OxO+j5UuPEg9xNmN+kIqpdq6fVnFpgx5xCaMNue52g=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    CoreServices
  ];

  # the crate version doesn't include all the files required to run tests
  doCheck = false;

  meta = with lib; {
    description = "A cargo plugin for showing a tree-like overview of a crate's modules";
    homepage = "https://github.com/regexident/cargo-modules";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ figsoda rvarago ];
  };
}
