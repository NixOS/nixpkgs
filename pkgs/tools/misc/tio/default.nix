{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  inih,
  lua,
  bash-completion,
  darwin,
}:

stdenv.mkDerivation rec {
  pname = "tio";
  version = "2.8";

  src = fetchFromGitHub {
    owner = "tio";
    repo = "tio";
    rev = "v${version}";
    hash = "sha256-BBfLmRhbDeymXXlYp71XTwbAab7h7gJ842fzZJNb6kU=";
  };

  strictDeps = true;

  buildInputs = [
    inih
    lua
  ] ++ lib.optionals (stdenv.hostPlatform.isDarwin) [ darwin.apple_sdk.frameworks.IOKit ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    bash-completion
  ];

  meta = with lib; {
    description = "Serial console TTY";
    homepage = "https://tio.github.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ yana ];
    platforms = platforms.unix;
    mainProgram = "tio";
  };
}
