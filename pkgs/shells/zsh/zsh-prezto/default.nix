{ lib, stdenv, fetchFromGitHub, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "zsh-prezto";
  version = "unstable-2021-01-19";

  src = fetchFromGitHub {
    owner = "sorin-ionescu";
    repo = "prezto";
    rev = "704fc46c3f83ca1055becce65fb513a533f48982";
    sha256 = "0rkbx6hllf6w6x64mggbhvm1fvbq5sr5kvf06sarfkpz5l0a5wh3";
    fetchSubmodules = true;
  };

  installPhase = ''
    mkdir -p $out/share/zsh-prezto
    cp -R ./ $out/share/zsh-prezto
  '';

  passthru.updateScript = unstableGitUpdater {};

  meta = with lib; {
    description = "The configuration framework for Zsh";
    longDescription = ''
      Prezto is the configuration framework for Zsh; it enriches
      the command line interface environment with sane defaults,
      aliases, functions, auto completion, and prompt themes.
    '';
    homepage = "https://github.com/sorin-ionescu/prezto";
    license = licenses.mit;
    maintainers = with maintainers; [ holymonson ];
    platforms = platforms.unix;
  };
}
