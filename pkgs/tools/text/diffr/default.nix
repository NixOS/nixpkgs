{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "diffr";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "mookid";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ylZE2NtTXbGqsxE72ylEQCacTyxBO+/WgvEpoXd5OZI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-pbGfoEk8peWBA0F0EdiAJJtan74O5RD6TmNJUTY2ijA=";

  buildInputs = (lib.optional stdenv.hostPlatform.isDarwin Security);

  preCheck = ''
    export DIFFR_TESTS_BINARY_PATH=$releaseDir/diffr
  '';

  meta = with lib; {
    description = "Yet another diff highlighting tool";
    mainProgram = "diffr";
    homepage = "https://github.com/mookid/diffr";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ davidtwco ];
  };
}
