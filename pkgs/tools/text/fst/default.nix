{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "fst";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = pname;
    rev = version;
    sha256 = "sha256-fXbX6idoGBtQiKM37C0z89OH/5H2PkZdwYLksXbbakE=";
  };

  cargoPatches = [
    # Add Cargo.lock lockfile, which upstream does not include
    ./0001-cargo-lockfile.patch
  ];

  cargoBuildFlags = [ "--workspace" ];
  cargoSha256 = "sha256-2gy4i4CwZP6LB5ea1LBSfeAV6bNnsvDbxw0Unur0Hm4=";

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
