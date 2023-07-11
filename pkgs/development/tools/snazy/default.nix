{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "snazy";
  version = "0.51.2";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = pname;
    rev = version;
    hash = "sha256-k8dcALE5+5kqNKhmiLT0Ir8SRYOIp8eV3a/xYWrKpNw=";
  };

  cargoHash = "sha256-mBA2BhGeYR57UrqI1qtByTkTocMymjCWlWhh4+Ko8wY=";

  cargoPatches = [
    # update Cargo.toml to fix the version
    # https://github.com/chmouel/snazy/pull/178
    (fetchpatch {
      name = "update-version-in-cargo-toml.patch";
      url = "https://github.com/chmouel/snazy/commit/4fd92c7336f51d032a0baf60fd5ab8c1056ad14f.patch";
      hash = "sha256-WT/HHB9HB+X/L5FZdvQAG8K7PrYHQD8F5aWQVaMJuIU=";
    })
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd snazy \
      --bash <($out/bin/snazy --shell-completion bash) \
      --fish <($out/bin/snazy --shell-completion fish) \
      --zsh <($out/bin/snazy --shell-completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/snazy --help
    $out/bin/snazy --version | grep "snazy ${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "A snazzy json log viewer";
    longDescription = ''
      Snazy is a simple tool to parse json logs and output them in a nice format
      with nice colors.
    '';
    homepage = "https://github.com/chmouel/snazy/";
    changelog = "https://github.com/chmouel/snazy/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda jk ];
  };
}
