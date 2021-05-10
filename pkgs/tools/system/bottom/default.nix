{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "bottom";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = pname;
    rev = version;
    sha256 = "sha256-9L7FtYIaWSOwNQ8zOLvxjt51o8A5MqqfF/iIyJs2TJA=";
  };

  prePatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.IOKit;

  cargoSha256 = "sha256-EYgfU7DVqboI3YMqYY5N89Rzltm5CHSZHJP/znGehxw=";

  doCheck = false;

  postInstall = ''
    installShellCompletion $releaseDir/build/bottom-*/out/btm.{bash,fish} --zsh $releaseDir/build/bottom-*/out/_btm
  '';

  meta = with lib; {
    description = "A cross-platform graphical process/system monitor with a customizable interface";
    homepage = "https://github.com/ClementTsang/bottom";
    license = licenses.mit;
    maintainers = with maintainers; [ berbiche ];
    platforms = platforms.unix;
    mainProgram = "btm";
  };
}
