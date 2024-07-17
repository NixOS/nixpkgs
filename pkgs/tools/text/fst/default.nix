{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "fst";
  version = "0.4.3";

  src = fetchCrate {
    inherit version;
    crateName = "fst-bin";
    sha256 = "sha256-x2rvLMOhatMWU2u5GAdpYy2uuwZLi3apoE6aaTF+M1g=";
  };

  cargoHash = "sha256-yTbEaw+BbjVks3j7/b75kGoUjVftLaVYvYIdI/bbfdk=";

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
    mainProgram = "fst";
    homepage = "https://github.com/BurntSushi/fst";
    license = with licenses; [
      unlicense # or
      mit
    ];
    maintainers = with maintainers; [ rmcgibbo ];
  };
}
