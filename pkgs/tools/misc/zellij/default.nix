{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, installShellFiles
, pkg-config
, libiconv
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "zellij";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = "zellij";
    rev = "v${version}";
    sha256 = "sha256-1GG3Bvw3P77dLhvJKwq48TUWMwg+bDgzWmtrw2JixLg=";
  };

  cargoSha256 = "sha256-cqm4QCGy6eTKtEBlE2ihmh93eO7d47zlCrLY8Gp0dxM=";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

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
