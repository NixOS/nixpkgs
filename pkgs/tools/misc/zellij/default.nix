{ lib, fetchFromGitHub, rustPlatform, stdenv, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "zellij";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "0x57g8va1b5ix3302qg9i5644w8s4lzfbz61nm7x1vq39i7rkdbk";
  };

  cargoSha256 = "03l3v2q7a8gqd88g1h209wqrr98v674467z6pl3im3l382dbwr4s";

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
