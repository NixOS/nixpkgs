{ lib, stdenv, fetchFromGitHub, coreutils, findutils, git, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "gibo";
  version = "2.2.8";

  src = fetchFromGitHub {
    owner = "simonwhitaker";
    repo = "gibo";
    rev = version;
    hash = "sha256-8Bqb1mz5C3F7EjfNfsyUwqDHnZhRH9SqW5HLA7IR6fQ=";
  };

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    cp gibo $out/bin
    installShellCompletion shell-completions/*.{bash,zsh,fish}

    find $out/ -type f -exec sed \
        -e 's|\<git |${git}/bin/git |g' \
        -e 's|\<basename |${coreutils}/bin/basename |g' \
        -e 's|\<find |${findutils}/bin/find |g' \
        -i {} \;
  '';

  meta = with lib; {
    homepage = "https://github.com/simonwhitaker/gibo";
    license = licenses.unlicense;
    description = "A shell script for easily accessing gitignore boilerplates";
    platforms = platforms.unix;
    maintainers = with maintainers; [ whyvert ];
  };
}
