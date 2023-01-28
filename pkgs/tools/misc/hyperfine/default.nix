{ lib
, rustPlatform
, fetchCrate
, installShellFiles
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "hyperfine";
  version = "1.15.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-JJ4sEwe2fXOGlofJ9SkXEllMCMhn7MSJ+H3aAF0F0zk=";
  };

  cargoSha256 = "sha256-3xOh51rUnQcUfQ+asurbfNYTb5dWQO5YY/AbGRV+26w=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optional stdenv.isDarwin Security;

  postInstall = ''
    installManPage doc/hyperfine.1

    installShellCompletion \
      $releaseDir/build/hyperfine-*/out/hyperfine.{bash,fish} \
      --zsh $releaseDir/build/hyperfine-*/out/_hyperfine
  '';

  meta = with lib; {
    description = "Command-line benchmarking tool";
    homepage = "https://github.com/sharkdp/hyperfine";
    changelog = "https://github.com/sharkdp/hyperfine/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda thoughtpolice ];
  };
}
