{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "bottom";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = pname;
    rev = version;
    hash = "sha256-9WQdudO2tIvxDHfJ87zvJeMfpuFSr4D5zGteL7Od2fQ=";
  };

  cargoHash = "sha256-aRN6V6r+JYi6yUcXei2f7l7oZ+8IkUmw1sgOwZJOtIE=";

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

  meta = with lib; {
    description = "A cross-platform graphical process/system monitor with a customizable interface";
    homepage = "https://github.com/ClementTsang/bottom";
    changelog = "https://github.com/ClementTsang/bottom/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ berbiche figsoda ];
    mainProgram = "btm";
  };
}
