{ stdenv
, fetchgit
, ghostscript
}:

stdenv.mkDerivation {
  pname = "ghostscript-test-corpus-render";
  version = "unstable-2022-12-01";

  src = fetchgit {
    url = "git://git.ghostscript.com/tests.git";
    rev = "e81c3a1d7c679aab8230e9152165d8cffb687242";
    hash = "sha256-h+UHpCHASYOhf4xG6gkVJK9TEG85kE3jNx5cD1I3LQg=";
  };

  dontConfigure = true;
  dontBuild = true;

  doCheck = true;
  checkPhase = ''
    find . -iregex '.*\.\(ps\|eps\|pdf\)' | while read f; do
      echo "Rendering $f"
      ${ghostscript}/bin/gs \
        -dNOPAUSE \
        -dBATCH \
        -sDEVICE=bitcmyk \
        -sOutputFile=/dev/null \
        -r600 \
        -dBufferSpace=100000 \
        $f
    done
  '';

  installPhase = ''
    touch $out
  '';
}
