{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "httm";
  version = "0.39.1";

  src = fetchFromGitHub {
    owner = "kimono-koans";
    repo = pname;
    rev = version;
    hash = "sha256-Wlmr2xI3RRiV8z+AhD1If3TSD/tBBFg3b9YNAximRk8=";
  };

  cargoHash = "sha256-9N+Yo82fx2mFrClk7H1fHhVS4lOX+us5Hs2EXmCbY4o=";

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    chmod +x scripts/*.bash
    patchShebangs scripts/*.bash
  '';

  postInstall = ''
    installManPage httm.1

    installShellCompletion --cmd httm \
      --zsh scripts/httm-key-bindings.zsh

    for script in scripts/*.bash; do
      install -Dm755 "$script" "$out/bin/$(basename "$script" .bash)"
    done

    install -Dm644 README.md $out/share/doc/README.md
  '';

  meta = with lib; {
    description = "Interactive, file-level Time Machine-like tool for ZFS/btrfs";
    homepage = "https://github.com/kimono-koans/httm";
    changelog = "https://github.com/kimono-koans/httm/releases/tag/${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ wyndon ];
    mainProgram = "httm";
  };
}
