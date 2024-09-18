{ stdenv, lib, fetchurl }:
let
  mkCmdPackDerivation = { pname, postInstall ? "", description }: stdenv.mkDerivation {
    inherit pname postInstall;

    version = "1.03";

    src = fetchurl {
      url = "https://web.archive.org/web/20140330233023/http://www.neillcorlett.com/downloads/cmdpack-1.03-src.tar.gz";
      sha256 = "0v0a9rpv59w8lsp1cs8f65568qj65kd9qp7854z1ivfxfpq0da2n";
    };

    buildPhase = ''
      runHook preBuild

      $CC -o "$pname" "src/$pname.c"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm555 -t "$out/bin" "$pname"

      runHook postInstall
    '';

    meta = with lib; {
      inherit description;

      homepage = "https://web.archive.org/web/20140330233023/http://www.neillcorlett.com/cmdpack/";
      platforms = platforms.all;
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ zane ];
    };
  };
in
{
  bin2iso = mkCmdPackDerivation {
    pname = "bin2iso";
    description = "Convert CD .BIN to .ISO";
  };

  bincomp = mkCmdPackDerivation {
    pname = "bincomp";
    description = "Compare binary files";
  };

  brrrip = mkCmdPackDerivation {
    pname = "brrrip";
    description = "Rip SNES BRR sound samples";
  };

  byteshuf = mkCmdPackDerivation {
    pname = "byteshuf";
    description = "Shuffle or unshuffle bytes in a file";
  };

  byteswap = mkCmdPackDerivation {
    pname = "byteswap";
    description = "Swap byte order of files";
  };

  cdpatch = mkCmdPackDerivation {
    pname = "cdpatch";
    description = "CD-XA image insert/extract utility";
  };

  ecm = mkCmdPackDerivation {
    pname = "ecm";
    postInstall = "ln $out/bin/ecm $out/bin/unecm";
    description = "Encoder/decoder for Error Code Modeler format";
  };

  fakecrc = mkCmdPackDerivation {
    pname = "fakecrc";
    description = "Fake the CRC32 of a file";
  };

  hax65816 = mkCmdPackDerivation {
    pname = "hax65816";
    description = "Simple 65816 disassembler";
  };

  id3point = mkCmdPackDerivation {
    pname = "id3point";
    description = "Pointless ID3v1 Tagger";
  };

  pecompat = mkCmdPackDerivation {
    pname = "pecompat";
    description = "Maximize compatibility of a Win32 PE file";
  };

  rels = mkCmdPackDerivation {
    pname = "rels";
    description = "Relative Searcher";
  };

  screamf = mkCmdPackDerivation {
    pname = "screamf";
    description = ".AMF to .S3M converter";
  };

  subfile = mkCmdPackDerivation {
    pname = "subfile";
    description = "Extract a portion of a file";
  };

  uips = mkCmdPackDerivation {
    pname = "uips";
    description = "Universal IPS patch create/apply utility";
  };

  usfv = mkCmdPackDerivation {
    pname = "usfv";
    description = "Universal SFV create/verify utility";
  };

  vb2rip = mkCmdPackDerivation {
    pname = "vb2rip";
    description = "VB2 sound format ripping utility";
  };

  wordadd = mkCmdPackDerivation {
    pname = "wordadd";
    description = "Addition word puzzle solver";
  };

  zerofill = mkCmdPackDerivation {
    pname = "zerofill";
    description = "Create a large, empty file";
  };
}
