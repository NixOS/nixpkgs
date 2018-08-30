{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gradle-completion-${version}";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "gradle";
    repo = "gradle-completion";
    rev = "v${version}";
    sha256 = "02vv360r78ckwc6r4xbhmy5dxz6l9ya4lq9c62zh12ciq94y9kgx";
  };

  # we just move two files into $out,
  # this shouldn't bother Hydra.
  preferLocalBuild = true;

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    install -Dm0644 ./_gradle $out/share/zsh/site-functions/_gradle
    install -Dm0644 ./gradle-completion.bash $out/share/bash-completion/completions/gradle

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Gradle tab completion for bash and zsh";
    homepage = https://github.com/gradle/gradle-completion;
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
