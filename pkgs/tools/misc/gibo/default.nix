{ stdenv, fetchFromGitHub, coreutils, findutils, git }:

stdenv.mkDerivation rec {
  pname = "gibo";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "simonwhitaker";
    repo = "gibo";
    rev = version;
    sha256 = "07j3sv9ar9l074krajw8nfmsfmdp836irsbd053dbqk2v880gfm6";
  };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/bin $out/share/bash-completion/completions
    cp gibo $out/bin
    cp gibo-completion.bash $out/share/bash-completion/completions

    sed -e 's|\<git |${git}/bin/git |g' \
        -e 's|\<basename |${coreutils}/bin/basename |g' \
        -i "$out/bin/gibo"
    sed -e 's|\<find |${findutils}/bin/find |g' \
        -i "$out/share/bash-completion/completions/gibo-completion.bash"
  '';

  meta = {
    homepage = "https://github.com/simonwhitaker/gibo";
    license = stdenv.lib.licenses.publicDomain;
    description = "A shell script for easily accessing gitignore boilerplates";
    platforms = stdenv.lib.platforms.unix;
  };
}
