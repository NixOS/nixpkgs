{
  lib,
  stdenv,
  buildGo121Module,
  fetchFromGitHub,
  installShellFiles,
}:
buildGo121Module rec {
  pname = "turso-cli";
  version = "0.85.3";

  nativeBuildInputs = [ installShellFiles ];

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "turso-cli";
    rev = "v${version}";
    hash = "sha256-dJpHrqPyikkUnE4Un1fGOEJL49U5IiInYeSWmI04r18=";
  };

  vendorHash = "sha256-Hv4CacBrRX2YT3AkbNzyWrA9Ex6YMDPrPvezukwMkTE=";

  # Build with production code
  tags = ["prod"];
  # Include version for `turso --version` reporting
  preBuild = ''
    echo "v${version}" > internal/cmd/version.txt
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd turso \
      --bash <($out/bin/turso completion bash) \
      --fish <($out/bin/turso completion fish) \
      --zsh <($out/bin/turso completion zsh)
  '';

  # Test_setDatabasesCache fails due to /homeless-shelter: read-only file system error.
  doCheck = false;

  meta = with lib; {
    description = "This is the command line interface (CLI) to Turso.";
    homepage = "https://turso.tech";
    mainProgram = "turso";
    license = licenses.mit;
    maintainers = with maintainers; [ zestsystem kashw2 fryuni ];
  };
}
