{ lib, fetchFromGitHub, rustPlatform }:

let
  commonMeta = {
    name = "tere";
    version = "1.1.0";
  };
  tereSrc = fetchFromGitHub {
    owner = "mgunyho";
    repo = commonMeta.name;
    rev = "v${commonMeta.version}";
    sha256 = "BD7onBkFyo/JAw/neqL9N9nBYSxoMrmaG6egeznV9Xs=";
  };
in
rustPlatform.buildRustPackage rec
  {
    pname = commonMeta.name;
    version = commonMeta.version;

    src = tereSrc;
    cargoSha256 = "gAq9ULQ2YFPmn4IsHaYrC0L7NqbPUWqXSb45ZjlMXEs=";

    # This test confirmed not working.
    # https://github.com/mgunyho/tere/issues/44
    cargoPatches = [ ./brokentest.patch ];

    meta = with lib; {
      description = "A faster alternative to cd + ls";
      homepage = "https://github.com/mgunyho/tere";
      licence = licenses.eupl12;
      maintainers = [ maintainers.ProducerMatt ];
    };
  }
