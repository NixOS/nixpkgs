{ lib, fetchFromGitHub, rustPlatform, stdenv, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "zellij";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-spESDjX7scihVQrr/f6KMCI9VfdTxxPWP7FcJ965FYk=";
  };

  cargoSha256 = "0rm31sfcj2d85w1l4hhfmva3j828dfhiv5br1mnpaqaa01zzs1q1";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  preCheck = ''
    HOME=$TMPDIR
  '';

  postInstall = ''
    installShellCompletion --cmd $pname \
      --bash <($out/bin/zellij generate-completion bash) \
      --fish <($out/bin/zellij generate-completion fish) \
      --zsh <($out/bin/zellij generate-completion zsh)
  '';

  meta = with lib; {
    description = "A terminal workspace with batteries included";
    homepage = "https://zellij.dev/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ therealansh _0x4A6F ];
  };
}
