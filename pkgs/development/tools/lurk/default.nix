{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "lurk";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "jakwai01";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JY5MSjHN8/n5iILgqjo6EOzuQRuTovAptMPh6oiJ7Zw=";
  };

  cargoHash = "sha256-cVGN5LZwjWijvVoAnz8LUyTImfT6KvgTGEg5JODGXHk=";

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
