{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubie";
  version = "0.25.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "sha256-aZM4rIYDEO1oezHeG2cL0O3hWrj7OJFzW/uFaX+cczw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xRm1c7c7hZg419+2SgMpfX2w5HhLGYVA5HF+GnBZ+Yg=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  postInstall = ''
    installShellCompletion completion/kubie.bash
  '';

  meta = with lib; {
    description = "Shell independent context and namespace switcher for kubectl";
    mainProgram = "kubie";
    homepage = "https://github.com/sbstp/kubie";
    license = with licenses; [ zlib ];
    maintainers = with maintainers; [ illiusdope ];
  };
}
