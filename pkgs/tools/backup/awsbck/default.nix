{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "awsbck";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "awsbck";
    rev = "v${version}";
    hash = "sha256-6AJTNJ/vuRAMnkuOoBVmEAlJy18OZDWVr4OzFv9/oag=";
  };

  cargoHash = "sha256-kJLkI+01tZMYnvxr8Gnuq7ia9iGEYrlUNvHv9Fg7L6s=";

  # tests run in CI on the source repo
  doCheck = false;

  meta = with lib; {
    description = "Backup a folder to AWS S3, once or periodically";
    homepage = "https://github.com/beeb/awsbck";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ beeb ];
    mainProgram = "awsbck";
  };
}
