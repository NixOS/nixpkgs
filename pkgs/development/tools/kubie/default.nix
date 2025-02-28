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
  version = "0.25.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "sha256-/TwM9ba8h5U+PGAcpXb7rAyWZjsAV+EOTFmiAHRCxQU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qb3BtNGTOdxhSVYRvp/4LjlchjIPJnyXEzxMu06EBEM=";

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
