{ lib
, rustPlatform
, fetchCrate
, stdenv
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "fst";
  version = "0.4.2";

  src = fetchCrate {
    inherit version;
    crateName = "fst-bin";
    sha256 = "sha256-m9JDVHy+o4RYLGkYnhOpTuLyJjXtOwwl2SQpzRuz1m0=";
  };

  cargoSha256 = "sha256-RMjNk8tE7AYBYgys4IjCCfgPdDgwbYVmrWpWNBOf70E=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  doInstallCheck = true;
  installCheckPhase = ''
    csv="$(mktemp)"
    fst="$(mktemp)"
    printf "abc,1\nabcd,1" > "$csv"
    $out/bin/fst map "$csv" "$fst" --force
    $out/bin/fst fuzzy "$fst" 'abc'
    $out/bin/fst --help > /dev/null
  '';

  meta = with lib; {
    description = "Represent large sets and maps compactly with finite state transducers";
    homepage = "https://github.com/BurntSushi/fst";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = with maintainers; [ rmcgibbo ];
  };
}
