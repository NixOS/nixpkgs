{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "byacc";
  version = "20221229";

  src = fetchurl {
    urls = let
      inherit (finalAttrs) pname version;
    in [
      "https://invisible-mirror.net/archives/byacc/${pname}-${version}.tgz"
      "ftp://ftp.invisible-island.net/byacc/${pname}-${version}.tgz"
    ];
    hash = "sha256-ExbG95D6+maIQn8f+RJnth2LeHO0Q8Yg7vaabv8FA7w=";
  };

  configureFlags = [
    "--program-transform-name='s,^,b,'"
  ];

  doCheck = true;

  postInstall = ''
    ln -s $out/bin/byacc $out/bin/yacc
  '';

  meta = with lib; {
    homepage = "https://invisible-island.net/byacc/byacc.html";
    description = "Berkeley YACC";
    longDescription = ''
      Berkeley Yacc (byacc) is generally conceded to be the best yacc variant
      available. In contrast to bison, it is written to avoid dependencies upon
      a particular compiler.

      Byacc was written around 1990 by Robert Corbett who is the original author
      of bison. Byacc is noted in Lex & Yacc by John Levine et al (O'Reilly,
      1992) for its compatibility with the original yacc program.

      Nowadays byacc is maintained by Thomas E. Dickey.
    '';
    changelog = "https://invisible-island.net/byacc/CHANGES.html";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
})
