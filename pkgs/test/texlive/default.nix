{ lib, stdenv, runCommand, fetchurl, file, texlive, writeShellScript, writeText }:

{

  tlpdbNix = runCommand "texlive-test-tlpdb-nix" {
    nixpkgsTlpdbNix = ../../tools/typesetting/tex/texlive/tlpdb.nix;
    tlpdbNix = texlive.tlpdb.nix;
  }
  ''
    mkdir -p "$out"
    diff -u "''${nixpkgsTlpdbNix}" "''${tlpdbNix}" | tee "$out/tlpdb.nix.patch"
  '';

  opentype-fonts = runCommand "texlive-test-opentype" {
    nativeBuildInputs = [
      (with texlive; combine { inherit scheme-medium libertinus-fonts; })
    ];
    input = builtins.toFile "opentype-testfile.tex" ''
      \documentclass{article}
      \usepackage{fontspec}
      \setmainfont{Libertinus Serif}
      \begin{document}
        \LaTeX{} is great
      \end{document}
    '';
  }
  ''
    export HOME="$(mktemp -d)"
    # We use the same testfile to test two completely different
    # font discovery mechanisms, both of which were once broken:
    #  - lualatex uses its own luaotfload script (#220228)
    #  - xelatex uses fontconfig (#228196)
    # both of the following two commands need to succeed.
    lualatex -halt-on-error "$input"
    xelatex -halt-on-error "$input"
    echo success > $out
  '';

  chktex = runCommand "texlive-test-chktex" {
    nativeBuildInputs = [
      (with texlive; combine { inherit scheme-infraonly chktex; })
    ];
    input = builtins.toFile "chktex-sample.tex" ''
      \documentclass{article}
      \begin{document}
        \LaTeX is great
      \end{document}
    '';
  } ''
    chktex -v -nall -w1 "$input" 2>&1 | tee "$out"
    grep "One warning printed" "$out"
  '';

  dvipng = lib.recurseIntoAttrs {
    # https://github.com/NixOS/nixpkgs/issues/75605
    basic = runCommand "texlive-test-dvipng-basic" {
      nativeBuildInputs = [ file texlive.combined.scheme-medium ];
      input = fetchurl {
        name = "test_dvipng.tex";
        url = "http://git.savannah.nongnu.org/cgit/dvipng.git/plain/test_dvipng.tex?id=b872753590a18605260078f56cbd6f28d39dc035";
        sha256 = "1pjpf1jvwj2pv5crzdgcrzvbmn7kfmgxa39pcvskl4pa0c9hl88n";
      };
    } ''
      cp "$input" ./document.tex

      latex document.tex
      dvipng -T tight -strict -picky document.dvi
      for f in document*.png; do
        file "$f" | tee output
        grep PNG output
      done

      mkdir "$out"
      mv document*.png "$out"/
    '';

    # test dvipng's limited capability to render postscript specials via GS
    ghostscript = runCommand "texlive-test-ghostscript" {
      nativeBuildInputs = [ file (with texlive; combine { inherit scheme-small dvipng; }) ];
      input = builtins.toFile "postscript-sample.tex" ''
        \documentclass{minimal}
        \begin{document}
          Ni
          \special{ps:
            newpath
            0 0 moveto
            7 7 rlineto
            0 7 moveto
            7 -7 rlineto
            stroke
            showpage
          }
        \end{document}
      '';
      gs_trap = writeShellScript "gs_trap.sh" ''
        exit 1
      '';
    } ''
      cp "$gs_trap" ./gs
      export PATH=$PWD:$PATH
      # check that the trap works
      gs && exit 1

      cp "$input" ./document.tex

      latex document.tex
      dvipng -T 1in,1in -strict -picky document.dvi
      for f in document*.png; do
        file "$f" | tee output
        grep PNG output
      done

      mkdir "$out"
      mv document*.png "$out"/
    '';
  };

  # https://github.com/NixOS/nixpkgs/issues/75070
  dvisvgm = runCommand "texlive-test-dvisvgm" {
    nativeBuildInputs = [ file texlive.combined.scheme-medium ];
    input = builtins.toFile "dvisvgm-sample.tex" ''
      \documentclass{article}
      \begin{document}
        mwe
      \end{document}
    '';
  } ''
    cp "$input" ./document.tex

    latex document.tex
    dvisvgm document.dvi -n -o document_dvi.svg
    cat document_dvi.svg
    file document_dvi.svg | grep SVG

    pdflatex document.tex
    dvisvgm -P document.pdf -n -o document_pdf.svg
    cat document_pdf.svg
    file document_pdf.svg | grep SVG

    mkdir "$out"
    mv document*.svg "$out"/
  '';

  texdoc = runCommand "texlive-test-texdoc" {
    nativeBuildInputs = [
      (with texlive; combine {
        inherit scheme-infraonly luatex texdoc;
        pkgFilter = pkg: lib.elem pkg.tlType [ "run" "bin" "doc" ];
      })
    ];
  } ''
    texdoc --version

    texdoc --debug --list texdoc | tee "$out"
    grep texdoc.pdf "$out"
  '';

  # test that language files are generated as expected
  hyphen-base = runCommand "texlive-test-hyphen-base" {
    hyphenBase = lib.head texlive.hyphen-base.pkgs;
    schemeFull = texlive.combined.scheme-full;
    schemeInfraOnly = texlive.combined.scheme-infraonly;
  } ''
    mkdir -p "$out"/{scheme-infraonly,scheme-full}

    # create language files with no hyphenation patterns
    cat "$hyphenBase"/tex/generic/config/language.us >language.dat
    cat "$hyphenBase"/tex/generic/config/language.us.def >language.def
    cat "$hyphenBase"/tex/generic/config/language.us.lua >language.dat.lua

    cat >>language.dat.lua <<EOF
    }
    EOF

    cat >>language.def <<EOF
    %%% No changes may be made beyond this point.

    \uselanguage {USenglish}             %%% This MUST be the last line of the file.
    EOF

    for fname in language.{dat,def,dat.lua} ; do
      diff --ignore-matching-lines='^\(%\|--\) Generated by ' -u \
        {"$hyphenBase","$schemeFull"/share/texmf-var}/tex/generic/config/"$fname" \
        | tee "$out/scheme-full/$fname.patch"
      diff --ignore-matching-lines='^\(%\|--\) Generated by ' -u \
        {,"$schemeInfraOnly"/share/texmf-var/tex/generic/config/}"$fname" \
        | tee "$out/scheme-infraonly/$fname.patch"
    done
  '';

  # test that fmtutil.cnf is fully regenerated on scheme-full
  fmtutilCnf = runCommand "texlive-test-fmtutil.cnf" {
    kpathsea = lib.head texlive.kpathsea.pkgs;
    schemeFull = texlive.combined.scheme-full;
  } ''
    mkdir -p "$out"

    diff --ignore-matching-lines='^# Generated by ' -u \
      {"$kpathsea","$schemeFull"/share/texmf-var}/web2c/fmtutil.cnf \
      | tee "$out/fmtutil.cnf.patch"
  '';

  # verify that the restricted mode gets enabled when
  # needed (detected by checking if it disallows --gscmd)
  repstopdf = runCommand "texlive-test-repstopdf" {
    nativeBuildInputs = [ (texlive.combine { inherit (texlive) scheme-infraonly epstopdf; }) ];
  } ''
    ! (epstopdf --gscmd echo /dev/null 2>&1 || true) | grep forbidden >/dev/null
    (repstopdf --gscmd echo /dev/null 2>&1 || true) | grep forbidden >/dev/null
    mkdir "$out"
  '';

  # check that all binaries run successfully, in the following sense:
  # (1) run --version, -v, --help, -h successfully; or
  # (2) run --help, -h, or no argument with error code but show help text; or
  # (3) run successfully on a test.tex or similar file
  # we ignore the binaries that cannot be tested as above, and are either
  # compiled binaries or trivial shell wrappers
  binaries = let
      # TODO known broken binaries
      broken = [ "albatross" "arara" "bbl2bib" "bib2gls" "bibdoiadd" "bibmradd" "bibzbladd" "citeproc" "convbkmk"
        "convertgls2bib" "ctan-o-mat" "ctanify" "ctanupload" "dtxgen" "ebong" "epspdftk" "exceltex" "gsx" "htcontext"
        "installfont-tl" "kanji-fontmap-creator" "ketcindy" "latex-git-log" "latex2nemeth" "ltxfileinfo" "match_parens"
        "pdfannotextractor" "purifyeps" "pythontex" "svn-multi" "texexec" "texosquery" "texosquery-jre5"
        "texosquery-jre8" "texplate" "tlcockpit" "tlmgr" "tlshell" "ulqda" "xhlatex" ];
      # (1) binaries requiring -v
      shortVersion = [ "devnag" "diadia" "pmxchords" "ptex2pdf" "simpdftex" "ttf2afm" ];
      # (1) binaries requiring --help or -h
      help = [ "arlatex" "bundledoc" "cachepic" "checklistings" "dvipos" "extractres" "fig4latex" "fragmaster"
        "kpsewhere" "mendex" "pn2pdf" "psbook" "psnup" "psresize" "simpdftex" "tex2xindy" "texluac" "texluajitc"
        "urlbst" "yplan" ];
      shortHelp = [ "adhocfilelist" "authorindex" "biburl2doi" "disdvi" "dvibook" "dviconcat" "getmapdl" "latex2man"
        "lprsetup.sh" "pygmentex" ];
      # (2) binaries that return non-zero exit code even if correctly asked for help
      ignoreExitCode = [ "authorindex" "dvibook" "dviconcat" "dvipos" "extractres" "fig4latex" "fragmaster" "latex2man"
        "lprsetup.sh" "pdf2dsc" "psbook" "psnup" "psresize" "tex2xindy" "texluac" "texluajitc" ];
      # (2) binaries that print help on no argument, returning non-zero exit code
      noArg = [ "a2ping" "bg5+latex" "bg5+pdflatex" "bg5latex" "bg5pdflatex" "cef5latex" "cef5pdflatex" "ceflatex"
        "cefpdflatex" "cefslatex" "cefspdflatex" "chkdvifont" "dvi2fax" "dvipdf" "dvired" "dviselect"
        "dvitodvi" "eps2eps" "epsffit" "findhyph" "gbklatex" "gbkpdflatex" "komkindex" "kpsepath" "listbib"
        "listings-ext" "mag" "mathspic" "mf2pt1" "mk4ht" "mkt1font" "mkgrkindex" "musixflx" "pdf2ps" "pdftosrc"
        "pdfxup" "pedigree" "pfb2pfa" "pfbtopfa" "pk2bm" "pphs" "prepmx" "ps2pk" "ps2pdf*" "ps2ps*" "psselect" "pstops"
        "rubibtex" "rubikrotation" "sjislatex" "sjispdflatex" "srcredact" "t4ht" "tex4ht" "texdiff" "texdirflatten"
        "texplate" "tie" "ttf2kotexfont" "ttfdump" "vlna" "vpl2ovp" "vpl2vpl" "yplan" ];
      # (3) binary requiring a .tex file
      tex = [ "de-macro" "e2pall" "makeindex" "pslatex" "rumakeindex" "tpic2pdftex" "wordcount" ];
      # tricky binaries or scripts that are obviously working but are hard to test
      # (e.g. because they expect user input no matter the arguments)
      # (printafm comes from ghostscript, not texlive)
      ignored = [ "dt2dv" "dv2dt" "dvi2tty" "dvidvi" "dvispc" "fontinst" "ht" "htlatex" "htmex" "httex" "httexi"
        "htxelatex" "htxetex" "otp2ocp" "outocp" "pmxab" "printafm" ];
      testTex = writeText "test.tex" ''
        \documentclass{article}
        \begin{document}
          A simple test file.
        \end{document}
      '';
    in
    runCommand "texlive-test-binaries" { inherit testTex; }
      ''
        mkdir -p "$out"
        export HOME="$(mktemp -d)"
        declare -i binCount=0 ignoredCount=0 brokenCount=0 failedCount=0
        cp "$testTex" test.tex

        testBin () {
          if [[ -z "$ignoreExitCode" ]] ; then
            "$bin" $args >"$out/$base.log" 2>&1
            return $?
          else
            "$bin" $args >"$out/$base.log" 2>&1
            ret=$?
            if ! grep -Ei '(Example:|Options:|Syntax:|Usage:|improper command|SYNOPSIS)' "$out/$base.log" >/dev/null ; then
              echo "did not find usage info when running '$base''${args:+ $args}'"
              return $ret
            fi
          fi
        }

        for bin in ${texlive.combined.scheme-full}/bin/* ; do
          base="''${bin##*/}"
          args=
          ignoreExitCode=
          binCount=$((binCount + 1))
          case "$base" in
            ${lib.concatStringsSep "|" ignored})
              ignoredCount=$((ignoredCount + 1))
              continue ;;
            ${lib.concatStringsSep "|" broken})
              brokenCount=$((brokenCount + 1))
              continue ;;
            ${lib.concatStringsSep "|" help})
              args=--help ;;
            ${lib.concatStringsSep "|" shortHelp})
              args=-h ;;
            ${lib.concatStringsSep "|" noArg})
              ;;
            ${lib.concatStringsSep "|" tex})
              args=test.tex ;;
            ${lib.concatStringsSep "|" shortVersion})
              args=-v ;;
            pdf2dsc)
              args='--help --help --help' ;;
            typeoutfileinfo)
              args=/dev/null ;;
            *)
              args=--version ;;
          esac

          case "$base" in
            ${lib.concatStringsSep "|" (ignoreExitCode ++ noArg)})
              ignoreExitCode=1 ;;
          esac

          if testBin ; then : ; else # preserve exit code
            echo "failed '$base''${args:+ $args}' (exit code: $?)"
            failedCount=$((failedCount + 1))
          fi
        done

        echo "tested $binCount binCount: $ignoredCount ignored, $brokenCount broken, $failedCount failed"
        [[ $failedCount = 0 ]]
      '';
}
