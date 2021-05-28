{ lib, fetchFromGitHub, rustPlatform, stdenv, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "zellij";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OgpSVyXvJeRpxHWfIoJjQbbkt2RSze0IL5za3igGE6s=";
  };

  cargoSha256 = "sha256-LgJPhwOuzlKIw5smy4WJvC0CFoylnMlx6Re7gVPtiq8=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  preCheck = ''
    HOME=$TMPDIR
  '';

  postInstall = ''
    installShellCompletion --cmd $pname \
      --bash <($out/bin/zellij setup --generate-completion bash) \
      --fish <($out/bin/zellij setup --generate-completion fish) \
      --zsh <($out/bin/zellij setup --generate-completion zsh)
  '';

  meta = with lib; {
    description = "A terminal workspace with batteries included";
    homepage = "https://zellij.dev/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ therealansh _0x4A6F ];
  };
}
