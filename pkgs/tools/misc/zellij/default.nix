{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, installShellFiles
, pkg-config
, libiconv
, openssl
, expect
}:

rustPlatform.buildRustPackage rec {
  pname = "zellij";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = "zellij";
    rev = "v${version}";
    sha256 = "sha256-2DYNgPURQzHaR8wHKEzuXSzubrxsQHpl3H3ko4okY7M=";
  };

  cargoSha256 = "sha256-AxtXWBfOzdLCpRchaQJbBBs+6rIyF+2ralOflRvkY4k=";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  preCheck = ''
    HOME=$TMPDIR
  '';

  postInstall = ''
    installShellCompletion --cmd $pname \
      --bash <(${expect}/bin/unbuffer $out/bin/zellij setup --generate-completion bash) \
      --fish <(${expect}/bin/unbuffer $out/bin/zellij setup --generate-completion fish) \
      --zsh <(${expect}/bin/unbuffer $out/bin/zellij setup --generate-completion zsh)
  '';

  meta = with lib; {
    description = "A terminal workspace with batteries included";
    homepage = "https://zellij.dev/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ therealansh _0x4A6F ];
  };
}
