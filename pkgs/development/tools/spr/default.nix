{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  Security,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "spr";
  version = "1.3.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-PrqDWrbGH80ByxK5S7Q1lpF+BGujqP6ilFM/6TqKSZ0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bzxcqYy0gWLGfm2JokabQvBFRhXv4ywDYdzxmG1nDac=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.hostPlatform.isDarwin Security;

  meta = with lib; {
    description = "Submit pull requests for individual, amendable, rebaseable commits to GitHub";
    mainProgram = "spr";
    homepage = "https://github.com/spacedentist/spr";
    license = licenses.mit;
    maintainers = with maintainers; [ spacedentist ];
  };
}
