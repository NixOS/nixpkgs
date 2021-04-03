{ lib, stdenv, fetchFromGitHub, coreutils, findutils, git }:

stdenv.mkDerivation rec {
  pname = "gibo";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "simonwhitaker";
    repo = "gibo";
    rev = version;
    sha256 = "0d3596yfyic6sarny23aw4yrb6gr7adpiw5cxx20fqj7xpw72m7a";
  };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/bin $out/share/bash-completion/completions
    cp gibo $out/bin
    cp shell-completions/gibo-completion.bash $out/share/bash-completion/completions

    sed -e 's|\<git |${git}/bin/git |g' \
        -e 's|\<basename |${coreutils}/bin/basename |g' \
        -i "$out/bin/gibo"
    sed -e 's|\<find |${findutils}/bin/find |g' \
        -i "$out/share/bash-completion/completions/gibo-completion.bash"
  '';

  meta = {
    homepage = "https://github.com/simonwhitaker/gibo";
    license = lib.licenses.publicDomain;
    description = "A shell script for easily accessing gitignore boilerplates";
    platforms = lib.platforms.unix;
  };
}
