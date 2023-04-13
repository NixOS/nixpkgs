{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, pcre
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ucg";
  version = "unstable-2019-02-25";

  src = fetchFromGitHub {
    owner = "gvansickle";
    repo = "ucg";
    rev = "c3a67632f1e3f332bfb102f0db167f34a2e42da7";
    hash = "sha256-/wU1PmI4ejlv7gZzZNasgROYXFiDiIxE9BFoCo6+G5Y=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    pcre
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    testFile=$(mktemp /tmp/ucg-test.XXXX)
    echo -ne 'Lorem ipsum dolor sit amet\n2.7182818284590' > $testFile
    $out/bin/ucg 'dolor' $testFile || { rm $testFile; exit -1; }
    $out/bin/ucg --ignore-case 'lorem' $testFile || { rm $testFile; exit -1; }
    $out/bin/ucg --word-regexp '2718' $testFile && { rm $testFile; exit -1; }
    $out/bin/ucg 'pisum' $testFile && { rm $testFile; exit -1; }
    rm $testFile

    runHook postInstallCheck
  '';

  meta =  {
    homepage = "https://github.com/gvansickle/ucg/";
    description = "Grep-like tool for searching large bodies of source code";
    longDescription = ''
      UniversalCodeGrep (ucg) is an extremely fast grep-like tool specialized
      for searching large bodies of source code. It is intended to be largely
      command-line compatible with Ack, to some extent with ag, and where
      appropriate with grep. Search patterns are specified as PCRE regexes.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
    broken = stdenv.isAarch64; # cpuid.h: no such file or directory
  };
})
# TODO: report upstream
