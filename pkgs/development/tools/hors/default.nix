{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "hors";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "windsoilder";
    repo = pname;
    rev = "v${version}";
    sha256 = "1q17i8zg7dwd8al42wfnkn891dy5hdhw4325plnihkarr50avbr0";
  };

  cargoSha256 = "sha256-1PB/JvgfC6qABI+cIePqtsSlZXPqMGQIay9SCXJkV9o=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  # requires network access
  doCheck = false;

  meta = with lib; {
    description = "Instant coding answers via the command line";
    mainProgram = "hors";
    homepage = "https://github.com/windsoilder/hors";
    changelog = "https://github.com/WindSoilder/hors/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
