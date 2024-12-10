{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bundlerEnv,
}:

stdenv.mkDerivation rec {
  pname = "evil-winrm";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "Hackplayers";
    repo = "evil-winrm";
    rev = "refs/tags/v${version}";
    hash = "sha256-8Lyo7BgypzrHMEcbYlxo/XWwOtBqs2tczYnc3+XEbeA=";
  };

  env = bundlerEnv {
    name = pname;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    env.wrappedRuby
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp evil-winrm.rb $out/bin/evil-winrm
  '';

  meta = with lib; {
    description = "WinRM shell for hacking/pentesting";
    mainProgram = "evil-winrm";
    homepage = "https://github.com/Hackplayers/evil-winrm";
    changelog = "https://github.com/Hackplayers/evil-winrm/blob/v${version}/CHANGELOG.md";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ elohmeier ];
  };
}
