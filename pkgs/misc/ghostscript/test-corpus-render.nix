{ stdenv
, fetchgit
, ghostscript
}:

stdenv.mkDerivation {
  pname = "ghostscript-test-corpus-render";
  version = "unstable-2020-02-19";

  src = fetchgit {
    url = "git://git.ghostscript.com/tests.git";
    rev = "efdd224340d9a407ed3ec22afa1cb127c8fee73c";
    sha256 = "1v1iqz897zzrwa8ng22zcf3y61ab5798jdwidgv10w1r9mjrl7ax";
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
