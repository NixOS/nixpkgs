{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, installShellFiles
, perl
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
  version = "0.39.2";

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = "zellij";
    rev = "v${version}";
    hash = "sha256-FSLbRfxSWY0a9H9iHT3oQ2SXwB70AwyH0Cm8sDZGaUk=";
  };

  cargoHash = "sha256-a5dFtK5czOGqE6mKeeI0kkY2da1kS3IRZ1NTluZ9Syc=";

  nativeBuildInputs = [
    mandown
    installShellFiles
    perl
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
    mainProgram = "zellij";
  };
}
