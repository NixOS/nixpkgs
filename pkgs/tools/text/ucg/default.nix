{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, pcre
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ucg";
  version = "unstable-2022-09-03";

  src = fetchFromGitHub {
    owner = "gvansickle";
    repo = "ucg";
    rev = "cbb185e8adad6546b7e1c5e9ca59a81f98dca49f";
    hash = "sha256-Osdyxp8DoEjcr2wQLCPqOQ2zQf/0JWYxaDpZB02ACWo=";
  };

  outputs = [ "out" "man" ];

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
    homepage = "https://gvansickle.github.io/ucg/";
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
    broken = stdenv.isAarch64 || stdenv.isDarwin;
  };
})
# TODO: report upstream
