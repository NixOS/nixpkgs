params: with params;
# combine =
args@{
  pkgFilter ? (pkg: pkg.tlType == "run" || pkg.tlType == "bin" || pkg.pname == "core")
, extraName ? "combined", ...
}:
let
  pkgSet = removeAttrs args [ "pkgFilter" "extraName" ] // {
    # include a fake "core" package
    core.pkgs = [
      (bin.core.out // { pname = "core"; tlType = "bin"; })
      (bin.core.doc // { pname = "core"; tlType = "doc"; })
    ];
  };
  partition = builtins.partition or (pred: l:
    { right = builtins.filter pred l; wrong = builtins.filter (e: !(pred e)) l; });
  pkgList = rec {
    all = lib.filter pkgFilter (combinePkgs pkgSet);
    splitBin = partition (p: p.tlType == "bin") all;
    bin = mkUniquePkgs splitBin.right
      ++ lib.optional
          (lib.any (p: p.tlType == "run" && p.pname == "pdfcrop") splitBin.wrong)
          (lib.getBin ghostscript);
    nonbin = mkUniquePkgs splitBin.wrong;

    # extra interpreters needed for shebangs, based on 2015 schemes "medium" and "tetex"
    # (omitted tk needed in pname == "epspdf", bin/epspdftk)
    pkgNeedsPython = pkg: pkg.tlType == "run" && lib.elem pkg.pname
      [ "de-macro" "pythontex" "dviasm" "texliveonfly" ];
    pkgNeedsRuby = pkg: pkg.tlType == "run" && pkg.pname == "match-parens";
    extraInputs =
      lib.optional (lib.any pkgNeedsPython splitBin.wrong) python
      ++ lib.optional (lib.any pkgNeedsRuby splitBin.wrong) ruby;
  };

  mkUniquePkgs = pkgs: fastUnique (a: b: a < b) # highlighting hack: >
    # here we deal with those dummy packages needed for hyphenation filtering
    (map (p: if lib.isDerivation p then p.outPath else "") pkgs);

in buildEnv {
  name = "texlive-${extraName}-${bin.texliveYear}";

  extraPrefix = "/share/texmf";

  ignoreCollisions = false;
  paths = pkgList.nonbin;

  buildInputs = [ makeWrapper ] ++ pkgList.extraInputs;

  postBuild = ''
    cd "$out"
    mkdir -p ./bin
  '' +
    lib.concatMapStrings
      (path: ''
        for f in '${path}'/bin/*; do
          if [[ -L "$f" ]]; then
            cp -d "$f" ./bin/
          else
            ln -s "$f" ./bin/
          fi
        done
      '')
      pkgList.bin
    +

    # Patch texlinks.sh back to 2015 version;
    # otherwise some bin/ links break, e.g. xe(la)tex.
  ''
    (
      cd "$out/share/texmf/scripts/texlive"
      local target="$(readlink texlinks.sh)"
      rm texlinks.sh && cp "$target" texlinks.sh
      patch --verbose -R texlinks.sh < '${./texlinks.diff}'
    )
  '' +
  ''
    export PATH="$out/bin:$out/share/texmf/scripts/texlive:${perl}/bin:$PATH"
    export TEXMFCNF="$out/share/texmf/web2c"
    export TEXMFDIST="$out/share/texmf"
    export TEXMFSYSCONFIG="$out/share/texmf-config"
    export TEXMFSYSVAR="$out/share/texmf-var"
    export PERL5LIB="$out/share/texmf/scripts/texlive"
  '' +
    # patch texmf-{dist,local} -> texmf to be sure
    # TODO: perhaps do lua actions?
    # tried inspiration from install-tl, sub do_texmf_cnf
  ''
    patchCnfLua() {
      local cnfLua="$1"

      if [ -e "$cnfLua" ]; then
        local cnfLuaOrig="$(realpath "$cnfLua")"
        rm ./texmfcnf.lua
        sed \
          -e 's,texmf-dist,texmf,g' \
          -e 's,texmf-local,texmf,g' \
          -e "s,\(TEXMFLOCAL[ ]*=[ ]*\)[^\,]*,\1\"$out/share/texmf\",g" \
          -e "s,\$SELFAUTOLOC,$out,g" \
          -e "s,selfautodir:/,$out/share/,g" \
          -e "s,selfautodir:,$out/share/,g" \
          -e "s,selfautoparent:/,$out/share/,g" \
          -e "s,selfautoparent:,$out/share/,g" \
          "$cnfLuaOrig" > "$cnfLua"
      fi
    }

    (
      cd ./share/texmf/web2c/
      local cnfOrig="$(realpath ./texmf.cnf)"
      rm ./texmf.cnf
      sed \
        -e 's,texmf-dist,texmf,g' \
        -e 's,texmf-local,texmf,g' \
        -e "s,\$SELFAUTOLOC,$out,g" \
        -e "s,\$SELFAUTODIR,$out/share,g" \
        -e "s,\$SELFAUTOPARENT,$out/share,g" \
        -e "s,\$SELFAUTOGRANDPARENT,$out/share,g" \
        -e "/^mpost,/d" `# CVE-2016-10243` \
        "$cnfOrig" > ./texmf.cnf

      patchCnfLua "./texmfcnf.lua"

      rm updmap.cfg
    )
  '' +
    # updmap.cfg seems like not needing changes

    # now filter hyphenation patterns, in a hacky way ATM
  (let script =
    writeText "hyphens.sed" (
      lib.concatMapStrings (pkg: "/^\% from ${pkg.pname}/,/^\%/p;\n") pkgList.splitBin.wrong
      + "1,/^\% from/p;" );
  in ''
    (
      cd ./share/texmf/tex/generic/config/
      for fname in language.dat language.def; do
        [ -e $fname ] || continue;
        cnfOrig="$(realpath ./$fname)"
        rm ./$fname
        cat "$cnfOrig" | sed -n -f '${script}' > ./$fname
      done
    )
  '') +

  # function to wrap created executables with required env vars
  ''
    wrapBin() {
    for link in ./bin/*; do
      [ -L "$link" -a -x "$link" ] || continue # if not link, assume OK
      local target=$(readlink "$link")

      # skip simple local symlinks; mktexfmt in particular
      echo "$target" | grep / > /dev/null || continue;

      echo -n "Wrapping '$link'"
      rm "$link"
      makeWrapper "$target" "$link" \
        --prefix PATH : "$out/bin:${perl}/bin" \
        --prefix PERL5LIB : "$out/share/texmf/scripts/texlive"

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
    mkdir -p "$out/share/texmf/scripts/texlive/"
    ln -s '${bin.core.out}/share/texmf-dist/scripts/texlive/TeXLive' "$out/share/texmf/scripts/texlive/"

    for tool in updmap; do
      ln -sf "$out/share/texmf/scripts/texlive/$tool."* "$out/bin/$tool"
    done
  '' +
    # now hack to preserve "$0" for mktexfmt
  ''
    cp "$out"/share/texmf/scripts/texlive/fmtutil.pl "$out/bin/fmtutil"
    patchShebangs "$out/bin/fmtutil"
    sed "1s|$| -I $out/share/texmf/scripts/texlive|" -i "$out/bin/fmtutil"
    ln -sf fmtutil "$out/bin/mktexfmt"

    perl `type -P mktexlsr.pl` ./share/texmf
    texlinks.sh "$out/bin" && wrapBin
    (perl `type -P fmtutil.pl` --sys --all || true) | grep '^fmtutil' # too verbose
    #texlinks.sh "$out/bin" && wrapBin # do we need to regenerate format links?
    perl `type -P updmap.pl` --sys --syncwithtrees --force
    perl `type -P mktexlsr.pl` ./share/texmf-* # to make sure
  '' +
    # install (wrappers for) scripts, based on a list from upstream texlive
  ''
    (
      cd "$out/share/texmf/scripts"
      source '${bin.core.out}/share/texmf-dist/scripts/texlive/scripts.lst'
      for s in $texmf_scripts; do
        [[ -x "./$s" ]] || continue
        tName="$(basename $s | sed 's/\.[a-z]\+$//')" # remove extension
        [[ ! -e "$out/bin/$tName" ]] || continue
        ln -sv "$(realpath $s)" "$out/bin/$tName" # wrapped below
      done
    )
    rm "$out"/bin/*-sys
    wrapBin
  '' +
  # TODO: a context trigger https://www.preining.info/blog/2015/06/debian-tex-live-2015-the-new-layout/
    # http://wiki.contextgarden.net/ConTeXt_Standalone#Unix-like_platforms_.28Linux.2FMacOS_X.2FFreeBSD.2FSolaris.29

    # I would just create links from "$out"/share/{man,info},
    #   but buildenv has problems with merging symlinks with directories;
    #   note: it's possible we might need deepen the work-around to man/*.
  ''
    for d in {man,info}; do
      [[ -e "./share/texmf/doc/$d" ]] || continue;
      (
        mkdir -p "./share/$d" && cd "./share/$d"
        ln -s -t . ../texmf/doc/"$d"/*
      )
    done
  ''
    + bin.cleanBrokenLinks
  ;
}
# TODO: make TeX fonts visible by fontconfig: it should be enough to install an appropriate file
#       similarly, deal with xe(la)tex font visibility?
