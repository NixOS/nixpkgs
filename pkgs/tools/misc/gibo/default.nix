{ stdenv, fetchFromGitHub, coreutils, findutils, git }:

stdenv.mkDerivation rec {
  name = "gibo-${version}";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "simonwhitaker";
    repo = "gibo";
    rev = version;
    sha256 = "1vzchggxv660c1cj5v0hlmln7yda48wjy2cv0qwi619cmr5hwbgh";
  };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/bin $out/etc/bash_completion.d
    cp gibo $out/bin
    cp gibo-completion.bash $out/etc/bash_completion.d

    sed -e 's|\<git |${git}/bin/git |g' \
        -e 's|\<basename |${coreutils}/bin/basename |g' \
        -i "$out/bin/gibo"
    sed -e 's|\<find |${findutils}/bin/find |g' \
        -i "$out/etc/bash_completion.d/gibo-completion.bash"
  '';

  meta = {
    homepage = https://github.com/simonwhitaker/gibo;
    license = stdenv.lib.licenses.publicDomain;
    description = "A shell script for easily accessing gitignore boilerplates";
    platforms = stdenv.lib.platforms.unix;
  };
}
