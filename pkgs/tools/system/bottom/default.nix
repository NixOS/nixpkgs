{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
, bottom
, testers
}:

rustPlatform.buildRustPackage rec {
  pname = "bottom";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = pname;
    rev = version;
    hash = "sha256-czOYEZevZD7GfExmqwB7vhLXl6+etag1PjZFA2G9aGA=";
  };

  cargoHash = "sha256-RDOGf1jujZikcRXRtL71BUGgmZyt7vQOTk1LkKpXDuo=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Foundation
  ];

  doCheck = false;

  postInstall = ''
    installManPage target/tmp/bottom/manpage/btm.1
    installShellCompletion \
      target/tmp/bottom/completion/btm.{bash,fish} \
      --zsh target/tmp/bottom/completion/_btm
  '';

  BTM_GENERATE = true;

  passthru.tests.version = testers.testVersion {
    package = bottom;
  };

  meta = with lib; {
    description = "Cross-platform graphical process/system monitor with a customizable interface";
    homepage = "https://github.com/ClementTsang/bottom";
    changelog = "https://github.com/ClementTsang/bottom/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ berbiche figsoda ];
    mainProgram = "btm";
  };
}
