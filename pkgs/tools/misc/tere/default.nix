{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tere";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "mgunyho";
    repo = "tere";
    rev = "v${version}";
    sha256 = "BD7onBkFyo/JAw/neqL9N9nBYSxoMrmaG6egeznV9Xs=";
  };

  cargoSha256 = "gAq9ULQ2YFPmn4IsHaYrC0L7NqbPUWqXSb45ZjlMXEs=";

  # This test confirmed not working.
  # https://github.com/mgunyho/tere/issues/44
  cargoPatches = [ ./brokentest.patch ];

  meta = with lib; {
    description = "A faster alternative to cd + ls";
    homepage = "https://github.com/mgunyho/tere";
    license = licenses.eupl12;
    maintainers = with maintainers; [ ProducerMatt ];
  };
}
