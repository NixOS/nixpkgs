{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "snazy";
  version = "0.51.3";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = pname;
    rev = version;
    hash = "sha256-YE11ypzOhRNjoi+X9Khp6qxqhD1f/hslr1t2cEeUTbs=";
  };

  cargoHash = "sha256-8oT9tdGeU/1mtgf470Ps4EwQmWxPhxAzmA8D30UG60o=";

  cargoPatches = [
    # update Cargo.toml to fix the version
    # https://github.com/chmouel/snazy/pull/217
    (fetchpatch {
      name = "update-version-in-cargo-toml.patch";
      url = "https://github.com/chmouel/snazy/commit/199f560e12d07c07c240bc91e7f929831af2cc4d.patch";
      hash = "sha256-X1oi4Mf1m/k/HYYJvqIrN14JJSEPUmWJt9PhzLiyYUs=";
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
