{ lib, rustPlatform, fetchCrate, bottom-rs, testVersion }:

rustPlatform.buildRustPackage rec {
  pname = "bottom-rs";
  version = "1.2.0";

  src = fetchCrate {
    inherit version;
    crateName = "bottomify";
    sha256 = "sha256-R1zj+TFXoolonIFa1zJDd7CdrORfzAPlxJoJVYe9xdc=";
  };

  cargoSha256 = "sha256-7xD65ookkK09XwCBH6fXqmWRYlmvpwAocojBg/dHzUI=";

  passthru.tests.version = testVersion { package = bottom-rs; };

  meta = with lib; {
    description = "Fantastic (maybe) CLI for translating between bottom and human-readable text";
    homepage = "https://github.com/bottom-software-foundation/bottom-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ winter ];
    mainProgram = "bottomify";
  };
}
