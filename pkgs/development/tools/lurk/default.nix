{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "lurk";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "jakwai01";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-99WdRyE2avoH5Ea277Dx/HNcOdWxOamR41W7dQQadpo=";
  };

  cargoHash = "sha256-BUIMtJCzK//bZuvn9iptBd7lVMGyWFNJ/0oTfwPu0DE=";

  postPatch = ''
    substituteInPlace src/lib.rs \
      --replace-fail '/usr/bin/ls' 'ls'
  '';

  meta = with lib; {
    description = "Simple and pretty alternative to strace";
    mainProgram = "lurk";
    homepage = "https://github.com/jakwai01/lurk";
    changelog = "https://github.com/jakwai01/lurk/releases/tag/${src.rev}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
