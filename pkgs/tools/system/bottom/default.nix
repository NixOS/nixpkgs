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
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = pname;
    rev = version;
    hash = "sha256-hm0Xfd/iW+431HflvZErjzeZtSdXVb/ReoNIeETJ5Ik=";
  };

  cargoHash = "sha256-FQbJx6ijX8kE4qxT7OQ7FwxLKJB5/moTKhBK0bfvBas=";

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
