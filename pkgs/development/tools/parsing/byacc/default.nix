{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "byacc";
  version = "20230219";

  src = fetchurl {
    urls = [
      "https://invisible-mirror.net/archives/byacc/byacc-${finalAttrs.version}.tgz"
      "ftp://ftp.invisible-island.net/byacc/byacc-${finalAttrs.version}.tgz"
    ];
    hash = "sha256-NrlyptSul1hN0YaSX7vDl9JssgYyp2wvUqx2U80IG1g=";
  };

  configureFlags = [
    # change yacc to byacc
    "--program-transform-name='s,^,b,'"
  ];

  doCheck = true;

  postInstall = ''
    ln -s $out/bin/byacc $out/bin/yacc
  '';

  meta = {
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
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
