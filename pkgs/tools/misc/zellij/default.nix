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
, zellij
, testVersion
}:

rustPlatform.buildRustPackage rec {
  pname = "zellij";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = "zellij";
    rev = "v${version}";
    sha256 = "sha256-MTSM8fYAcNcmjg6bkOEN+U5+WilaEy52EJOfyoIy3Zg=";
  };

  cargoSha256 = "sha256-2QEDrxTz7I9hF+WfVKkGLXHWZjQ5by/zuO16NGOJSKk=";

  nativeBuildInputs = [
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
    installShellCompletion --cmd $pname \
      --bash <($out/bin/zellij setup --generate-completion bash) \
      --fish <($out/bin/zellij setup --generate-completion fish) \
      --zsh <($out/bin/zellij setup --generate-completion zsh)
  '';

  passthru.tests.version = testVersion { package = zellij; };

  meta = with lib; {
    description = "A terminal workspace with batteries included";
    homepage = "https://zellij.dev/";
    changelog = "https://github.com/zellij-org/zellij/blob/v${version}/Changelog.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ therealansh _0x4A6F abbe ];
  };
}
