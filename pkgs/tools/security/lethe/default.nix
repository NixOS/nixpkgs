{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "lethe";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "kostassoid";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-y2D/80pnpYpTl+q9COTQkvtj9lzBlOWuMcnn5WFnX8E=";
  };

  cargoHash = "sha256-SFNNpbHZdDJvH95f+VWyVKnQp3OJwQmCOqHtLAhhkOk=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin Security;

  meta = {
    description = "Tool to wipe drives in a secure way";
    homepage = "https://github.com/kostassoid/lethe";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "lethe";
  };
}
