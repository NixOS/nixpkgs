{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "krapslog";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "acj";
    repo = "krapslog-rs";
    rev = version;
    sha256 = "sha256-zBtoKU9OHo1hyCgyQVAb3fsEW/IHwISht8VAss7LLq4=";
  };

  cargoHash = "sha256-gZr79VmvZrGglF6aC6j2c45ueJytgUslzBT5fyM3/V8=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Visualize a log file with sparklines";
    homepage = "https://github.com/acj/krapslog-rs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ yanganto ];
  };
}
