{ stdenv
, fetchFromGitHub
, lib
, makeWrapper
, autoreconfHook
, python3
, fontforge
, potrace
, texlive
}:

/*
  To use with a texlive distribution, ensure that the desired fonts and
  the packages kpathsea, t1utils, metafont are available at runtime.

  Possible overrides:
  - potrace = autotrace
  - fontforge = ghostscript (limited functionality)
  - fontforge = null (limited functionality)
*/

stdenv.mkDerivation (finalAttrs: rec {
  pname = "mftrace";
  version = "1.2.20";

  # https://lilypond.org/download/sources/mftrace/mftrace-1.2.20.tar.gz
  # is incomplete, fetch repo and use autoconf instead
  # see https://github.com/hanwen/mftrace/issues/13
  src = fetchFromGitHub {
    owner = "hanwen";
    repo = "mftrace";
    rev = "release/${version}";
    sha256 = "02ik25aczkbi10jrjlnxby3fmixxrwm2k5r4fkfif3bjfym7nqbc";
  };

  nativeBuildInputs = [ makeWrapper autoreconfHook python3 potrace ];

  buildInputs = [ fontforge potrace ];

  postInstall = ''
    wrapProgram $out/bin/mftrace --prefix PATH : ${lib.makeBinPath finalAttrs.buildInputs}
  '';

  # experimental texlive.combine support
  # (note that only the bin/ folder will be combined into texlive)
  passthru.tlDeps = with texlive; [ kpathsea t1utils metafont ];

  meta = with lib; {
    description = "Scalable PostScript Fonts for MetaFont";
    longDescription = ''
      mftrace is a small Python program that lets you trace a TeX bitmap
      font into a PFA or PFB font (A PostScript Type1 Scalable Font) or
      TTF (TrueType) font.
    '';
    homepage = "https://lilypond.org/mftrace/";
    license = with licenses; [ gpl2Only mit ];
    maintainers = with maintainers; [ xworld21 ];
    platforms = platforms.all;
  };
})
