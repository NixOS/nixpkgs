{ lib
, rustPlatform
, fetchCrate
, installShellFiles
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "planus";
  version = "0.4.0";

  src = fetchCrate {
    pname = "planus-cli";
    inherit version;
    hash = "sha256-KpX4KSA2MjfRS8M0WVYpY4hoSvOOB7MUz7YKZwEGqj8=";
  };

  cargoHash = "sha256-yT/ZK5GG0rXpiaCQlQclK2iY8BXhhmiW/UDX9aL8wBQ=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd planus \
      --bash <($out/bin/planus generate-completions bash) \
      --fish <($out/bin/planus generate-completions fish) \
      --zsh <($out/bin/planus generate-completions zsh)
  '';

  meta = with lib; {
    description = "An alternative compiler for flatbuffers";
    mainProgram = "planus";
    homepage = "https://github.com/planus-org/planus";
    changelog = "https://github.com/planus-org/planus/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
