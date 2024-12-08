# shellcheck shell=bash

# Replicate the post install phase of the upstream TeX Live installer.
#
# This script is based on the install-tl script and the TeXLive::TLUtils perl
# module, down to using the same (prefixed) function names and log messages.
#
# When updating to the next TeX Live release, review install-tl for changes and
# update this script accordingly.

### install-tl

# adjust texmf.cnf and texmfcnf.lua
installtl_do_texmf_cnf () {
    # unlike install-tl, we make a copy of the entire texmf.cnf
    # and point the binaries at $TEXMFCNF/texmf.cnf via wrappers

    mkdir -p "$TEXMFCNF"
    if [[ -e $texmfdist/web2c/texmfcnf.lua ]]; then
        tlutils_info "writing texmfcnf.lua to $TEXMFCNF/texmfcnf.lua"
        sed -e "s,\(TEXMFOS[ ]*=[ ]*\)[^\,]*,\1\"$texmfroot\",g" \
            -e "s,\(TEXMFDIST[ ]*=[ ]*\)[^\,]*,\1\"$texmfdist\",g" \
            -e "s,\(TEXMFSYSVAR[ ]*=[ ]*\)[^\,]*,\1\"$TEXMFSYSVAR\",g" \
            -e "s,\(TEXMFSYSCONFIG[ ]*=[ ]*\)[^\,]*,\1\"$TEXMFSYSCONFIG\",g" \
            -e "s,\(TEXMFLOCAL[ ]*=[ ]*\)[^\,]*,\1\"$out/share/texmf-local\",g" \
            -e "s,\$SELFAUTOLOC,$out,g" \
            -e "s,selfautodir:/,$out/share/,g" \
            -e "s,selfautodir:,$out/share/,g" \
            -e "s,selfautoparent:/,$out/share/,g" \
            -e "s,selfautoparent:,$out/share/,g" \
            "$texmfdist/web2c/texmfcnf.lua" > "$TEXMFCNF/texmfcnf.lua"
    fi

    tlutils_info "writing texmf.cnf to $TEXMFCNF/texmf.cnf"
    sed -e "s,\(TEXMFROOT[ ]*=[ ]*\)[^\,]*,\1$texmfroot,g" \
        -e "s,\(TEXMFDIST[ ]*=[ ]*\)[^\,]*,\1$texmfdist,g" \
        -e "s,\(TEXMFSYSVAR[ ]*=[ ]*\)[^\,]*,\1$TEXMFSYSVAR,g" \
        -e "s,\(TEXMFSYSCONFIG[ ]*=[ ]*\)[^\,]*,\1$TEXMFSYSCONFIG,g" \
        -e "s,\$SELFAUTOLOC,$out,g" \
        -e "s,\$SELFAUTODIR,$out/share,g" \
        -e "s,\$SELFAUTOPARENT,$out/share,g" \
        -e "s,\$SELFAUTOGRANDPARENT,$out/share,g" \
        "$texmfdist/web2c/texmf.cnf" > "$TEXMFCNF/texmf.cnf"
}

# run postaction scripts from texlive.tlpdb
# note that the other postactions (fileassoc, ...) are Windows only
installtl_do_tlpdb_postactions () {
    local postaction postInterp
    if [[ -n $postactionScripts ]] ; then
        tlutils_info "running package-specific postactions"
        for postaction in $postactionScripts ; do
            # see TeXLive::TLUtils::_installtl_do_postaction_script
            case "$postaction" in
                *.pl)
                    postInterp=perl ;;
                *.texlua)
                    postInterp=texlua ;;
                *)
                    postInterp= ;;
            esac
            tlutils_info "${postInterp:+$postInterp }$postaction install $texmfroot"
            FORCE_SOURCE_DATE=1 $postInterp "$texmfroot/$postaction" install "$texmfroot" >>"$TEXMFSYSVAR/postaction-${postaction##*/}.log"
        done
        tlutils_info "finished with package-specific postactions"
    fi
}

installtl_do_path_adjustments () {
    # here install-tl would add a system symlink to the man pages
    # instead we run other nixpkgs related adjustments

    # generate wrappers
    tlutils_info "wrapping binaries"

    local bash cmd extraPaths link path target wrapCount
    bash="$(command -v bash)"
    enable -f "${bash%/bin/bash}"/lib/bash/realpath realpath

    # common runtime dependencies
    for cmd in cat awk sed grep gs ; do
        # do not fail if gs is absent
        path="$(PATH="$HOST_PATH" command -v "$cmd" || :)"
        if [[ -n $path ]] ; then
            extraPaths="${extraPaths:+$extraPaths:}${path%/"$cmd"}"
        fi
    done

    declare -i wrapCount=0
    for link in "$out"/bin/* ; do
        target="$(realpath "$link")"

        # skip non-executable files (such as context.lua)
        if [[ ! -x $target ]] ; then
            continue
        fi

        if [[ ${target##*/} != "${link##*/}" ]] ; then
            # detected alias with different basename, use immediate target of $link to preserve $0
            # relevant for mktexfmt, repstopdf, ...
            target="$(readlink "$link")"
        fi

        rm "$link"
        makeWrapper "$target" "$link" \
            --inherit-argv0 \
            --prefix PATH : "$extraPaths:$out/bin" \
            --set-default TEXMFCNF "$TEXMFCNF" \
            --set-default FONTCONFIG_FILE "$fontconfigFile"
        wrapCount=$((wrapCount + 1))
    done

    tlutils_info "wrapped $wrapCount binaries and scripts"

    # generate format symlinks (using fmtutil.cnf)
    tlutils_info "generating format symlinks"
    texlinks --quiet "$out/bin"

    # remove *-sys scripts since /nix/store is readonly
    rm "$out"/bin/*-sys

    # link TEXMFDIST in $out/share for backward compatibility
    ln -s "$texmfdist" "$out"/share/texmf

    # generate other outputs
    local otherOutput otherOutputName
    local otherOutputs="$otherOutputs"
    for otherOutputName in $outputs ; do
        if [[ $otherOutputName == out ]] ; then
            continue
        fi
        otherOutput="${otherOutputs%% *}"
        otherOutputs="${otherOutputs#* }"
        ln -s "$otherOutput" "${!otherOutputName}"
    done
}

# run all post install parts
installtl_do_postinst_stuff () {
    installtl_do_texmf_cnf

    # create various config files
    # in principle, we could use writeText and share them across different
    # environments, but the eval & build overhead is not worth the savings
    tlutils_create_fmtutil
    # can be skipped if generating formats only
    if [[ -z $__formatsOf ]] ; then
        tlutils_create_updmap
    fi
    tlutils_create_language_dat
    tlutils_create_language_def
    tlutils_create_language_lua

    # make new files available
    tlutils_info "running mktexlsr $TEXMFSYSVAR $TEXMFSYSCONFIG"
    mktexlsr "$TEXMFSYSVAR" "$TEXMFSYSCONFIG"

    # can be skipped if generating formats only
    if [[ -z $__formatsOf ]] ; then
        # update font maps
        tlutils_info "generating font maps"
        updmap-sys --quiet --force --nohash 2>&1
        # configure the paper size
        # tlmgr --no-execute-actions paper letter
        # install-tl: "rerun mktexlsr for updmap-sys and tlmgr paper updates"
        tlutils_info "re-running mktexlsr $TEXMFSYSVAR $TEXMFSYSCONFIG"
        mktexlsr "$TEXMFSYSVAR" "$TEXMFSYSCONFIG"

        tlutils_update_context_cache
    fi

    # generate formats
    # install-tl would run fmtutil-sys $common_fmtutil_args --no-strict --all
    # instead, we want fmtutil to exit with error on failure
    if [[ -n $fmtutilCnf && -n $__combine$__formatsOf ]] ; then
        tlutils_info "pre-generating all format files, be patient..."
        # many formats still ignore SOURCE_DATE_EPOCH even when FORCE_SOURCE_DATE=1
        # libfaketime fixes non-determinism related to timestamps ignoring FORCE_SOURCE_DATE
        # we cannot fix further randomness caused by luatex; for further details, see
        # https://salsa.debian.org/live-team/live-build/-/blob/master/examples/hooks/reproducible/2006-reproducible-texlive-binaries-fmt-files.hook.chroot#L52
        # note that calling faketime and fmtutil is fragile (faketime uses LD_PRELOAD, fmtutil calls /bin/sh, causing potential glibc issues on non-NixOS)
        # so we patch fmtutil to use faketime, rather than calling faketime fmtutil
        substitute "$texmfdist"/scripts/texlive/fmtutil.pl fmtutil \
            --replace-fail "my \$cmdline = \"\$eng -ini " "my \$cmdline = \"faketime -f '\@$(date +'%F %T' --date=@"$SOURCE_DATE_EPOCH") x0.001' \$eng -ini "
        FORCE_SOURCE_DATE=1 perl fmtutil --quiet --strict --sys --all 2>&1 | grep '^fmtutil' # too verbose

        # if generating formats only, delete everything else and exit
        if [[ -n $__formatsOf ]] ; then
            # see fmtutil.pl::compute_format_destination for file extensions
            find "$out" \( -type f -or -type l \) \
                -not -path "$TEXMFSYSVAR/*.mem" \
                -not -path "$TEXMFSYSVAR/*.base" \
                -not -path "$TEXMFSYSVAR/*.fmt" \
                -delete
            find "$out" -type d -empty -delete
            exit
        fi
    elif [[ -z $__combine ]] ; then
        # double check that all formats are present
        if fmtutil --quiet --strict --sys --missing --dry-run 2>&1 | grep running ; then
            tlutils_info 'formats not found, aborting'
            exit 1
        fi
    fi

    installtl_do_path_adjustments

    installtl_do_tlpdb_postactions

    # remove log files to improve reproducibility
    find "$TEXMFSYSVAR" -name '*.log' -delete
}

### TeXLive::TLUtils

tlutils_info () {
    printf "texlive${__formatsOf:+($__formatsOf-fmt)}: %s\n" "$*"
}

tlutils_create_fmtutil () {
    # fmtutil.cnf created by install-tl already exists readonly in $texmfdist
    # so here we need to *disable* the entries that are not in $fmtutilCnf
    # and write the output in the writeable $TEXMFSYSVAR

    local engine fmt line outFile sedExpr
    outFile="$TEXMFSYSVAR"/web2c/fmtutil.cnf

    tlutils_info "writing fmtutil.cnf to $outFile"

    while IFS= read -r line ; do
        # a line is 'fmt engine ...' or '#! fmt engine ...'
        # (see fmtutil.pl::read_fmtutil_file)
        line="${line#\#! }"
        read -r fmt engine _ <<<"$line"
        # if a line for the ($fmt,$engine) pair exists, remove it to avoid
        # pointless warnings from fmtutil
        sedExpr="$sedExpr /^(#! )?$fmt $engine /d;"
    done <<<"$fmtutilCnf"

    # disable all the remaining formats
    sedExpr="$sedExpr /^[^#]/{ s/^/#! /p };"

    {
        echo "# Generated by nixpkgs"
        sed -E -n -e "$sedExpr" "$texmfdist"/web2c/fmtutil.cnf
        [[ -z $fmtutilCnf ]] || printf '%s' "$fmtutilCnf"
    } >"$outFile"
}

tlutils_create_updmap () {
    # updmap.cfg created by install-tl already exists readonly in $texmfdist
    # so here we need to *disable* the entries that are not in $updmapCfg
    # and write the output in the writeable $TEXMFSYSVAR

    local line map outFile sedExpr
    outFile="$TEXMFSYSVAR"/web2c/updmap.cfg

    tlutils_info "writing updmap.cfg to $outFile"

    while IFS= read -r line ; do
        # a line is 'type map' or '#! type map'
        # (see fmtutil.pl::read_updmap_file)
        read -r _ map <<<"$line"
        # if a line for $map exists, remove it to avoid
        # pointless warnings from updmap
        sedExpr="$sedExpr /^(#! )?[^ ]*Map $map$/d;"
    done <<<"$updmapCfg"

    # disable all the remaining font maps
    sedExpr="$sedExpr /^[^ ]*Map/{ s/^/#! /p };"

    {
        echo "# Generated by nixpkgs"
        sed -E -n -e "$sedExpr" "$texmfdist"/web2c/updmap.cfg
        [[ -z $updmapCfg ]] || printf '%s' "$updmapCfg"
    } >"$outFile"
}

tlutils__create_config_files () {
    # simplified arguments
    local header="$1"
    local dest="$2"
    local prefix="$3"
    local lines="$4"
    local suffix="$5"
    if [[ -z "$header" || -e "$header" ]] ; then
        tlutils_info "writing ${dest##*/} to $dest"
        {
            [[ -z $prefix ]] || printf '%s\n' "$prefix"
            [[ ! -e $header ]] || cat "$header"
            [[ -z $lines ]] || printf '%s\n' "$lines"
            [[ -z $suffix ]] || printf '%s\n' "$suffix"
        } >"$dest"
    fi
}

tlutils_create_language_dat () {
    tlutils__create_config_files \
        "$texmfdist"/tex/generic/config/language.us \
        "$TEXMFSYSVAR"/tex/generic/config/language.dat \
        '% Generated by nixpkgs' \
        "$languageDat" \
        ''
}

tlutils_create_language_def () {
    tlutils__create_config_files \
        "$texmfdist"/tex/generic/config/language.us.def \
        "$TEXMFSYSVAR"/tex/generic/config/language.def \
        '' \
        "$languageDef" \
        '%%% No changes may be made beyond this point.

\uselanguage {USenglish}             %%% This MUST be the last line of the file.'
}

tlutils_create_language_lua () {
    tlutils__create_config_files \
        "$texmfdist"/tex/generic/config/language.us.lua \
        "$TEXMFSYSVAR"/tex/generic/config/language.dat.lua \
        '-- Generated by nixpkgs' \
        "$languageLua" \
        '}'
}

tlutils_update_context_cache () {
    if [[ -x $out/bin/mtxrun ]] ; then
        tlutils_info "setting up ConTeXt cache"

        # temporarily patch mtxrun.lua to generate uuid's deterministically from SOURCE_DATE_EPOCH
        mv "$out"/bin/mtxrun.lua{,.orig}
        substitute "$out"/bin/mtxrun.lua.orig "$out"/bin/mtxrun.lua \
            --replace-fail 'randomseed(math.initialseed)' "randomseed($SOURCE_DATE_EPOCH)"

        # this is very verbose, save the output for debugging purposes
        {
            mtxrun --generate
            context --luatex --generate
            [[ ! -x $out/bin/luajittex ]] || context --luajittex --generate
        } >"$TEXMFSYSVAR"/context-cache.log

        mv "$out"/bin/mtxrun.lua{.orig,}
    fi
}

# init variables (export only the ones that are used in the wrappers)
export PATH="$out/bin:$PATH"
TEXMFSYSCONFIG="$out/share/texmf-config"
TEXMFSYSVAR="$out/share/texmf-var"
export TEXMFCNF="$TEXMFSYSVAR/web2c"

installtl_do_postinst_stuff
