{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "bottom";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = pname;
    rev = version;
    sha256 = "sha256-i1Vd2SA7Xb62gTVY6FdKzNe6ItfYrLXfgo0+VRm+Wdc=";
  };

  cargoHash = "sha256-umBBUbkgVIj9d2eYEJCHjoo0AjH9K2R6C+cps+PkZcA=";

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
