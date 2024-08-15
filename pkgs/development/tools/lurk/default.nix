{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "lurk";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "jakwai01";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-u37q5AJe6zsPNe5L+k3uVP7r92X4v3qhApPKYndZif4=";
  };

  cargoHash = "sha256-1hKyrlCDsOe+F88lg4+I5JMxG44CN2MOLi4GlaDBctk=";

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
