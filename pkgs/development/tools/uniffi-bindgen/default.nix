{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, ktlint
, yapf
, rubocop
, rustfmt
, libiconv
, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname = "uniffi-bindgen";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "uniffi-rs";
    rev = "v${version}";
    hash = "sha256-EGyJrW0U/dnKT7OWgd8LehCyvj6mxud3QWbBVyhoK4Y=";
  };

  cargoPatches = [ ./cargo-lock.patch ];
  cargoHash = "sha256-Fw+yCAI32NdFKJGPuNU6t0FiEfohoVD3VQfInNJuooI=";

  cargoBuildFlags = [ "-p uniffi_bindgen" ];
  cargoTestFlags = [ "-p uniffi_bindgen" ];
  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
  ];

  postFixup = ''
    wrapProgram "$out/bin/uniffi-bindgen" \
      --suffix PATH : ${lib.strings.makeBinPath [ rustfmt ktlint yapf rubocop ] }
  '';

  meta = with lib; {
    description = "Toolkit for building cross-platform software components in Rust";
    homepage = "https://mozilla.github.io/uniffi-rs/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ vtuan10 ];
  };
}
