{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gradle-completion";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "gradle";
    repo = "gradle-completion";
    rev = "v${version}";
    sha256 = "15b0692i3h8h7b95465b2aw9qf5qjmjag5n62347l8yl7zbhv3l2";
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
    maintainers = with maintainers; [ ];
  };
}
