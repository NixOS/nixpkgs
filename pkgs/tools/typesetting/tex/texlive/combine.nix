params: with params;
# combine =
args@{
  pkgFilter ? (pkg: pkg.tlType == "run" || pkg.tlType == "bin" || pkg.pname == "core")
, extraName ? "combined"
, extraVersion ? ""
, ...
}:
let
  pkgSet = removeAttrs args [ "pkgFilter" "extraName" "extraVersion" ] // {
    # include a fake "core" package
    core.pkgs = [
      (bin.core.out // { pname = "core"; tlType = "bin"; })
      (bin.core.doc // { pname = "core"; tlType = "doc"; })
    ];
  };
  pkgList = rec {
    all = lib.filter pkgFilter (combinePkgs (lib.attrValues pkgSet));
    splitBin = builtins.partition (p: p.tlType == "bin") all;
    bin = splitBin.right
      ++ lib.optional
          (lib.any (p: p.tlType == "run" && p.pname == "pdfcrop") splitBin.wrong)
          (lib.getBin ghostscript);
    nonbin = splitBin.wrong;

    # extra interpreters needed for shebangs, based on 2015 schemes "medium" and "tetex"
    # (omitted tk needed in pname == "epspdf", bin/epspdftk)
    pkgNeedsPython = pkg: pkg.tlType == "run" && lib.elem pkg.pname
      [ "de-macro" "pythontex" "dviasm" "texliveonfly" ];
    pkgNeedsRuby = pkg: pkg.tlType == "run" && pkg.pname == "match-parens";
    extraInputs =
      lib.optional (lib.any pkgNeedsPython splitBin.wrong) python3
      ++ lib.optional (lib.any pkgNeedsRuby splitBin.wrong) ruby;
  };

  name = "texlive-${extraName}-${bin.texliveYear}${extraVersion}";

  texmfroot = (buildEnv {
    name = "${name}-texmfroot";

    # the 'non-relocated' packages must live in $TEXMFROOT/texmf-dist (e.g. fmtutil, updmap look for perl modules there)
    extraPrefix = "/texmf-dist";

    # remove fake derivations (without 'outPath') to avoid undesired build dependencies
    paths = lib.catAttrs "outPath" pkgList.nonbin;

    nativeBuildInputs = [ perl bin.core.out ];

    postBuild = # generate ls-R database
    ''
      perl -I "${bin.core.out}/share/texmf-dist/scripts/texlive" \
        -- "$out/texmf-dist/scripts/texlive/mktexlsr.pl" --sort "$out"/texmf-dist
    '';
  }).overrideAttrs (_: { allowSubstitutes = true; });

  # expose info and man pages in usual /share/{info,man} location
  doc = buildEnv {
    name = "${name}-doc";

    paths = [ (texmfroot.outPath + "/texmf-dist/doc") ];
    extraPrefix = "/share";

    pathsToLink = [
      "/info"
      "/man"
    ];
  };

in (buildEnv {

  inherit name;

  ignoreCollisions = false;

  # remove fake derivations (without 'outPath') to avoid undesired build dependencies
  paths = lib.catAttrs "outPath" pkgList.bin ++ [ doc ];
  pathsToLink = [
    "/"
    "/bin" # ensure these are writeable directories
  ];

  nativeBuildInputs = [ makeWrapper libfaketime perl bin.texlinks ];
  buildInputs = pkgList.extraInputs;

  passthru = {
    # This is set primarily to help find-tarballs.nix to do its job
    packages = pkgList.all;
    # useful for inclusion in the `fonts.fonts` nixos option or for use in devshells
    fonts = "${texmfroot}/texmf-dist/fonts";
  };

  postBuild = ''
    TEXMFROOT="${texmfroot}"
    TEXMFDIST="${texmfroot}/texmf-dist"
    export PATH="$out/bin:$PATH"
    export PERL5LIB="${bin.core.out}/share/texmf-dist/scripts/texlive" # modules otherwise found in tlpkg/ of texlive.infra
    TEXMFSYSCONFIG="$out/share/texmf-config"
    TEXMFSYSVAR="$out/share/texmf-var"
    export TEXMFCNF="$TEXMFSYSVAR/web2c"
  '' +
    # patch texmf-dist  -> $TEXMFDIST
    # patch texmf-local -> $out/share/texmf-local
    # patch texmf.cnf   -> $TEXMFSYSVAR/web2c/texmf.cnf
    # TODO: perhaps do lua actions?
    # tried inspiration from install-tl, sub do_texmf_cnf
  ''
    mkdir -p "$TEXMFCNF"
    if [ -e "$TEXMFDIST/web2c/texmfcnf.lua" ]; then
      sed \
        -e "s,\(TEXMFOS[ ]*=[ ]*\)[^\,]*,\1\"$TEXMFROOT\",g" \
        -e "s,\(TEXMFDIST[ ]*=[ ]*\)[^\,]*,\1\"$TEXMFDIST\",g" \
        -e "s,\(TEXMFSYSVAR[ ]*=[ ]*\)[^\,]*,\1\"$TEXMFSYSVAR\",g" \
        -e "s,\(TEXMFSYSCONFIG[ ]*=[ ]*\)[^\,]*,\1\"$TEXMFSYSCONFIG\",g" \
        -e "s,\(TEXMFLOCAL[ ]*=[ ]*\)[^\,]*,\1\"$out/share/texmf-local\",g" \
        -e "s,\$SELFAUTOLOC,$out,g" \
        -e "s,selfautodir:/,$out/share/,g" \
        -e "s,selfautodir:,$out/share/,g" \
        -e "s,selfautoparent:/,$out/share/,g" \
        -e "s,selfautoparent:,$out/share/,g" \
        "$TEXMFDIST/web2c/texmfcnf.lua" > "$TEXMFCNF/texmfcnf.lua"
    fi

    sed \
      -e "s,\(TEXMFROOT[ ]*=[ ]*\)[^\,]*,\1$TEXMFROOT,g" \
      -e "s,\(TEXMFDIST[ ]*=[ ]*\)[^\,]*,\1$TEXMFDIST,g" \
      -e "s,\(TEXMFSYSVAR[ ]*=[ ]*\)[^\,]*,\1$TEXMFSYSVAR,g" \
      -e "s,\(TEXMFSYSCONFIG[ ]*=[ ]*\)[^\,]*,\1$TEXMFSYSCONFIG,g" \
      -e "s,\$SELFAUTOLOC,$out,g" \
      -e "s,\$SELFAUTODIR,$out/share,g" \
      -e "s,\$SELFAUTOPARENT,$out/share,g" \
      -e "s,\$SELFAUTOGRANDPARENT,$out/share,g" \
      -e "/^mpost,/d" `# CVE-2016-10243` \
      "$TEXMFDIST/web2c/texmf.cnf" > "$TEXMFCNF/texmf.cnf"
  '' +
    # now filter hyphenation patterns and formats
  (let
    hyphens = lib.filter (p: p.hasHyphens or false && p.tlType == "run") pkgList.splitBin.wrong;
    hyphenPNames = map (p: p.pname) hyphens;
    formats = lib.filter (p: p.hasFormats or false && p.tlType == "run") pkgList.splitBin.wrong;
    formatPNames = map (p: p.pname) formats;
    # sed expression that prints the lines in /start/,/end/ except for /end/
    section = start: end: "/${start}/,/${end}/{ /${start}/p; /${end}/!p; };\n";
    script =
      writeText "hyphens.sed" (
        # document how the file was generated (for language.dat)
        "1{ s/^(% Generated by .*)$/\\1, modified by texlive.combine/; p; }\n"
        # pick up the header
        + "2,/^% from/{ /^% from/!p; };\n"
        # pick up all sections matching packages that we combine
        + lib.concatMapStrings (pname: section "^% from ${pname}:$" "^% from|^%%% No changes may be made beyond this point.$") hyphenPNames
        # pick up the footer (for language.def)
        + "/^%%% No changes may be made beyond this point.$/,$p;\n"
      );
    scriptLua =
      writeText "hyphens.lua.sed" (
        "1{ s/^(-- Generated by .*)$/\\1, modified by texlive.combine/; p; }\n"
        + "2,/^-- END of language.us.lua/p;\n"
        + lib.concatMapStrings (pname: section "^-- from ${pname}:$" "^}$|^-- from") hyphenPNames
        + "$p;\n"
      );
    # formats not being installed must be disabled by prepending #! (see man fmtutil)
    # sed expression that enables the formats in /start/,/end/
    enableFormats = pname: "/^# from ${pname}:$/,/^# from/{ s/^#! //; };\n";
    fmtutilSed =
      writeText "fmtutil.sed" (
        # document how file was generated
        "1{ s/^(# Generated by .*)$/\\1, modified by texlive.combine/; }\n"
        # disable all formats, even those already disabled
        + "s/^([^#]|#! )/#! \\1/;\n"
        # enable the formats from the packages being installed
        + lib.concatMapStrings enableFormats formatPNames
        # clean up formats that have been disabled twice
        + "s/^#! #! /#! /;\n"
      );
  in ''
    mkdir -p "$TEXMFSYSVAR/tex/generic/config"
    for fname in tex/generic/config/language.{dat,def}; do
      [[ -e "$TEXMFDIST/$fname" ]] && sed -E -n -f '${script}' "$TEXMFDIST/$fname" > "$TEXMFSYSVAR/$fname"
    done
    [[ -e "$TEXMFDIST"/tex/generic/config/language.dat.lua ]] && sed -E -n -f '${scriptLua}' \
      "$TEXMFDIST"/tex/generic/config/language.dat.lua > "$TEXMFSYSVAR"/tex/generic/config/language.dat.lua
    [[ -e "$TEXMFDIST"/web2c/fmtutil.cnf ]] && sed -E -f '${fmtutilSed}' "$TEXMFDIST"/web2c/fmtutil.cnf > "$TEXMFCNF"/fmtutil.cnf

    # make new files visible to kpathsea
    perl "$TEXMFDIST"/scripts/texlive/mktexlsr.pl --sort "$TEXMFSYSVAR"
  '') +

  # function to wrap created executables with required env vars
  ''
    wrapBin() {
    for link in "$out"/bin/*; do
      [ -L "$link" -a -x "$link" ] || continue # if not link, assume OK
      local target=$(readlink "$link")

      # skip simple local symlinks; mktexfmt in particular
      echo "$target" | grep / > /dev/null || continue;

      echo -n "Wrapping '$link'"
      rm "$link"
      makeWrapper "$target" "$link" \
        --prefix PATH : "${gnused}/bin:${gnugrep}/bin:${coreutils}/bin:$out/bin:${perl}/bin" \
        --prefix PERL5LIB : "$PERL5LIB" \
        --set-default TEXMFCNF "$TEXMFCNF" \
        --set-default FONTCONFIG_FILE "${
          # neccessary for XeTeX to find the fonts distributed with texlive
          makeFontsConf { fontDirectories = [ "${texmfroot}/texmf-dist/fonts" ]; }
        }"

      # avoid using non-nix shebang in $target by calling interpreter
      if [[ "$(head -c 2 "$target")" = "#!" ]]; then
        local cmdline="$(head -n 1 "$target" | sed 's/^\#\! *//;s/ *$//')"
        local relative=`basename "$cmdline" | sed 's/^env //' `
        local newInterp=`echo "$relative" | cut -d\  -f1`
        local params=`echo "$relative" | cut -d\  -f2- -s`
        local newPath="$(type -P "$newInterp")"
        if [[ -z "$newPath" ]]; then
          echo " Warning: unknown shebang '$cmdline' in '$target'"
          continue
        fi
        echo " and patching shebang '$cmdline'"
        sed "s|^exec |exec $newPath $params |" -i "$link"

      elif head -n 1 "$target" | grep -q 'exec perl'; then
        # see #24343 for details of the problem
        echo " and patching weird perl shebang"
        sed "s|^exec |exec '${perl}/bin/perl' -w |" -i "$link"

      else
        sed 's|^exec |exec -a "$0" |' -i "$link"
        echo
      fi
    done
    }
  '' +
  # texlive post-install actions
  ''
    ln -sf "$TEXMFDIST"/scripts/texlive/updmap.pl "$out"/bin/updmap
  '' +
    # now hack to preserve "$0" for mktexfmt
  ''
    cp "$TEXMFDIST"/scripts/texlive/fmtutil.pl "$out/bin/fmtutil"
    patchShebangs "$out/bin/fmtutil"
    ln -sf fmtutil "$out/bin/mktexfmt"

    texlinks "$out/bin" && wrapBin

    # many formats still ignore SOURCE_DATE_EPOCH even when FORCE_SOURCE_DATE=1
    # libfaketime fixes non-determinism related to timestamps ignoring FORCE_SOURCE_DATE
    # we cannot fix further randomness caused by luatex; for further details, see
    # https://salsa.debian.org/live-team/live-build/-/blob/master/examples/hooks/reproducible/2006-reproducible-texlive-binaries-fmt-files.hook.chroot#L52
    FORCE_SOURCE_DATE=1 TZ= faketime -f '@1980-01-01 00:00:00 x0.001' fmtutil --sys --all | grep '^fmtutil' # too verbose
    #texlinks "$out/bin" && wrapBin # do we need to regenerate format links?

    # Disable unavailable map files
    echo y | updmap --sys --syncwithtrees --force
    # Regenerate the map files (this is optional)
    updmap --sys --force

    # sort entries to improve reproducibility
    [[ -f "$TEXMFSYSCONFIG"/web2c/updmap.cfg ]] && sort -o "$TEXMFSYSCONFIG"/web2c/updmap.cfg "$TEXMFSYSCONFIG"/web2c/updmap.cfg

    perl "$TEXMFDIST"/scripts/texlive/mktexlsr.pl --sort "$TEXMFSYSCONFIG" "$TEXMFSYSVAR" # to make sure
  '' +
    # install (wrappers for) scripts, based on a list from upstream texlive
  ''
    source '${bin.core.out}/share/texmf-dist/scripts/texlive/scripts.lst'
    for s in $texmf_scripts; do
      [[ -x "$TEXMFDIST/scripts/$s" ]] || continue
      tName="$(basename $s | sed 's/\.[a-z]\+$//')" # remove extension
      [[ ! -e "$out/bin/$tName" ]] || continue
      ln -sv "$(realpath "$TEXMFDIST/scripts/$s")" "$out/bin/$tName" # wrapped below
    done
  '' +
    # A hacky way to provide repstopdf
    #  * Copy is done to have a correct "$0" so that epstopdf enables the restricted mode
    #  * ./bin/repstopdf needs to be a symlink to be processed by wrapBin
  ''
    if [[ -e "$out"/bin/epstopdf ]]; then
      mkdir -p "$TEXMFSYSVAR/scripts"
      cp "$out"/bin/epstopdf "$TEXMFSYSVAR"/scripts/repstopdf
      ln -s "$TEXMFSYSVAR"/scripts/repstopdf "$out"/bin/repstopdf
    fi
  '' +
    # finish up the wrappers
  ''
    rm "$out"/bin/*-sys
    wrapBin
  '' +
    # Perform a small test to verify that the restricted mode get enabled when
    # needed (detected by checking if it disallows --gscmd)
  ''
    if [[ -e "$out"/bin/epstopdf ]]; then
      echo "Testing restricted mode for {,r}epstopdf"
      ! (epstopdf --gscmd echo /dev/null 2>&1 || true) | grep forbidden
      (repstopdf --gscmd echo /dev/null 2>&1 || true) | grep forbidden
    fi
  '' +
  # TODO: a context trigger https://www.preining.info/blog/2015/06/debian-tex-live-2015-the-new-layout/
    # http://wiki.contextgarden.net/ConTeXt_Standalone#Unix-like_platforms_.28Linux.2FMacOS_X.2FFreeBSD.2FSolaris.29

  # MkIV uses its own lookup mechanism and we need to initialize
  # caches for it.
  # We use faketime to fix the embedded timestamps and patch the uuids
  # with some random but constant values.
  ''
    if [[ -e "$out/bin/mtxrun" ]]; then
      substitute "$TEXMFDIST"/scripts/context/lua/mtxrun.lua mtxrun.lua \
        --replace 'cache_uuid=osuuid()' 'cache_uuid="e2402e51-133d-4c73-a278-006ea4ed734f"' \
        --replace 'uuid=osuuid(),' 'uuid="242be807-d17e-4792-8e39-aa93326fc871",'
      FORCE_SOURCE_DATE=1 TZ= faketime -f '@1980-01-01 00:00:00 x0.001' luatex --luaonly mtxrun.lua --generate
    fi
  ''
    + bin.cleanBrokenLinks +
  # Get rid of all log files. They are not needed, but take up space
  # and render the build unreproducible by their embedded timestamps
  # and other non-deterministic diagnostics.
  ''
    find "$TEXMFSYSVAR"/web2c -name '*.log' -delete
  ''
  ;
}).overrideAttrs (_: { allowSubstitutes = true; })
