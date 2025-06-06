{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "yarn-bash-completion";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "dsifford";
    repo = "yarn-completion";
    rev = "v${version}";
    sha256 = "0xflbrbwskjqv3knvc8jqygpvfxh5ak66q7w22d1ng8gwrfqzcng";
  };

  strictDeps = true;
  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    installShellCompletion --cmd yarn ./yarn-completion.bash

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/dsifford/yarn-completion/";
    description = "Bash completion for Yarn";
    license = licenses.mit;
    maintainers = with maintainers; [ DamienCassou ];
  };
}
