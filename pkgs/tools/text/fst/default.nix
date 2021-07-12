{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "fst";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = pname;
    rev = version;
    sha256 = "01qdj7zzgwb1zqcznfmnks3dnl6hnf8ib0sm0sgimsbcvajmhab3";
  };

  cargoPatches = [
    # Add Cargo.lock lockfile, which upstream does not include
    ./0001-cargo-lockfile.patch
  ];

  cargoBuildFlags = [ "--workspace" ];
  cargoSha256 = "0440p0hb3nlq9wwk3zac9dldanslrddvqn4gib0vl7aikxkcvh4l";

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
