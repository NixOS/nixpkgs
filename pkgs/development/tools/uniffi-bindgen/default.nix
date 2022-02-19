{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, ktlint
, yapf
, rubocop
, rustfmt
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

  cargoLock.lockFileContents = builtins.readFile ./Cargo.lock;
  cargoHash = "sha256-Fw+yCAI32NdFKJGPuNU6t0FiEfohoVD3VQfInNJuooI=";

  cargoBuildFlags = [ "-p uniffi_bindgen" ];
  cargoTestFlags = [ "-p uniffi_bindgen" ];
  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

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
