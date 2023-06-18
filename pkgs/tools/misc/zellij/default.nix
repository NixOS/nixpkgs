{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, installShellFiles
, pkg-config
, libiconv
, openssl
, DiskArbitration
, Foundation
, mandown
, zellij
, testers
}:

rustPlatform.buildRustPackage rec {
  pname = "zellij";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = "zellij";
    rev = "v${version}";
    sha256 = "sha256-6gILa7Q9s/AiXdoH/aaHPPpDmWeTKk5s274Bbk2e0V8=";
  };

  cargoSha256 = "sha256-SYkXxWR3Onp8y6kx0SSMQxgJqh1Wp1g1RNgZAs5kgqE=";

  nativeBuildInputs = [
    mandown
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
    DiskArbitration
    Foundation
  ];

  preCheck = ''
    HOME=$TMPDIR
  '';

  postInstall = ''
    mandown docs/MANPAGE.md > zellij.1
    installManPage zellij.1

    installShellCompletion --cmd $pname \
      --bash <($out/bin/zellij setup --generate-completion bash) \
      --fish <($out/bin/zellij setup --generate-completion fish) \
      --zsh <($out/bin/zellij setup --generate-completion zsh)
  '';

  passthru.tests.version = testers.testVersion { package = zellij; };

  meta = with lib; {
    description = "A terminal workspace with batteries included";
    homepage = "https://zellij.dev/";
    changelog = "https://github.com/zellij-org/zellij/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ therealansh _0x4A6F abbe thehedgeh0g ];
  };
}
