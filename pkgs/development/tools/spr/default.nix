{ lib
, rustPlatform
, fetchCrate
, Security
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "spr";
  version = "1.3.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ozirfRyJWgs5+CWZrXkIHzlNQcUOEAuX/XV+VrUnJC8=";
  };

  cargoSha256 = "sha256-Khua8g/vk0KTBmca37VhiBSHvfi8tKVhqxDYeJ594Qg=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Submit pull requests for individual, amendable, rebaseable commits to GitHub";
    homepage = "https://github.com/getcord/spr";
    license = licenses.mit;
    maintainers = with maintainers; [ sven-of-cord ];
  };
}
