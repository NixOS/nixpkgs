{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "bottom";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = pname;
    rev = version;
    sha256 = "sha256-UbzWI3f1ewFwg7BsqcvPZFeJt5E6alShxNuIKy+Tno0=";
  };

  cargoHash = "sha256-ihCgaB+vP5YyqMIg8qrkCEvSQdc6Eq00D1r3PGc2WpA=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
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
