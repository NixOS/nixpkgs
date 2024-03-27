# shellcheck shell=bash

# Replicate the post install phase of the upstream TeX Live installer.
#
# This script is based on the install-tl script and the associated TeXLive::TL*
# perl modules, down to using the same function names and log messages.
#
# When updating to the next TeX Live release, review install-tl for changes and
# update this script accordingly.

nixpkgs_texlive_log () {
    printf '%s\n' "texlive: $*"
}

### install-tl

# adjust texmf.cnf and texmfcnf.lua
do_texmf_cnf () {
    # unlike install-tl, we make a copy of the entire texmf.cnf
    # and point the binaries at $TEXMFCNF/texmf.cnf via wrappers

    mkdir -p "$TEXMFCNF"
    if [[ -e $TEXMFDIST/web2c/texmfcnf.lua ]]; then
        nixpkgs_texlive_log "writing texmfcnf.lua to $TEXMFCNF/texmfcnf.lua"
        sed -e "s,\(TEXMFOS[ ]*=[ ]*\)[^\,]*,\1\"$TEXMFROOT\",g" \
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

    nixpkgs_texlive_log "writing texmf.cnf to $TEXMFCNF/texmf.cnf"
    sed -e "s,\(TEXMFROOT[ ]*=[ ]*\)[^\,]*,\1$TEXMFROOT,g" \
        -e "s,\(TEXMFDIST[ ]*=[ ]*\)[^\,]*,\1$TEXMFDIST,g" \
        -e "s,\(TEXMFSYSVAR[ ]*=[ ]*\)[^\,]*,\1$TEXMFSYSVAR,g" \
        -e "s,\(TEXMFSYSCONFIG[ ]*=[ ]*\)[^\,]*,\1$TEXMFSYSCONFIG,g" \
        -e "s,\$SELFAUTOLOC,$out,g" \
        -e "s,\$SELFAUTODIR,$out/share,g" \
        -e "s,\$SELFAUTOPARENT,$out/share,g" \
        -e "s,\$SELFAUTOGRANDPARENT,$out/share,g" \
        "$TEXMFDIST/web2c/texmf.cnf" > "$TEXMFCNF/texmf.cnf"
}

# run postaction scripts from texlive.tlpdb
# note that the other postactions (fileassoc, ...) are Windows only
do_tlpdb_postactions () {
    local postaction postInterp
    if [[ -n $postactionScripts ]] ; then
        nixpkgs_texlive_log "running package-specific postactions"
        for postaction in $postactionScripts ; do
            # see TeXLive::TLUtils::_do_postaction_script
            case "$postaction" in
                *.pl)
                    postInterp=perl ;;
                *.texlua)
                    postInterp=texlua ;;
                *)
                    postInterp= ;;
            esac
            nixpkgs_texlive_log "${postInterp:+$postInterp }$postaction install $TEXMFROOT"
            FORCE_SOURCE_DATE=1 TZ='' $postInterp "$TEXMFROOT/$postaction" install "$TEXMFROOT" >>"$TEXMFSYSVAR/postaction-${postaction##*/}.log"
        done
        nixpkgs_texlive_log "finished with package-specific postactions"
    fi
}

do_path_adjustments () {
    # here install-tl would add a system symlink to the man pages
    # instead we run other nixpkgs related adjustments

    # generate wrappers
    nixpkgs_texlive_log "wrapping binaries"

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

    nixpkgs_texlive_log "wrapped $wrapCount binaries and scripts"

    # generate format symlinks (using fmtutil.cnf)
    nixpkgs_texlive_log "generating format symlinks"
    texlinks --quiet "$out/bin"

    # remove *-sys scripts since /nix/store is readonly
    rm "$out"/bin/*-sys

    # link TEXMFDIST in $out/share for backward compatibility
    ln -s "$TEXMFDIST" "$out"/share/texmf

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
do_postinst_stuff () {
    do_texmf_cnf

    # create various config files
    # in principle, we could use writeText and share them across different
    # environments, but the eval & build overhead is not worth the savings
    create_fmtutil
    create_updmap
    create_language_dat
    create_language_def
    create_language_lua

    # make new files available
    nixpkgs_texlive_log "running mktexlsr $TEXMFSYSVAR $TEXMFSYSCONFIG"
    mktexlsr "$TEXMFSYSVAR" "$TEXMFSYSCONFIG"

    # update font maps
    nixpkgs_texlive_log "generating font maps"
    updmap-sys --quiet --force --nohash 2>&1
    # configure the paper size
    # tlmgr --no-execute-actions paper letter
    # install-tl: "rerun mktexlsr for updmap-sys and tlmgr paper updates"
    nixpkgs_texlive_log "re-running mktexlsr $TEXMFSYSVAR $TEXMFSYSCONFIG"
    mktexlsr "$TEXMFSYSVAR" "$TEXMFSYSCONFIG"

    update_context_cache

    # generate formats
    # install-tl would run fmtutil-sys $common_fmtutil_args --no-strict --all
    # instead, we want fmtutil to exit with error on failure
    if [[ -n $fmtutilCnf ]] ; then
        nixpkgs_texlive_log "pre-generating all format files, be patient..."
        # many formats still ignore SOURCE_DATE_EPOCH even when FORCE_SOURCE_DATE=1
        # libfaketime fixes non-determinism related to timestamps ignoring FORCE_SOURCE_DATE
        # we cannot fix further randomness caused by luatex; for further details, see
        # https://salsa.debian.org/live-team/live-build/-/blob/master/examples/hooks/reproducible/2006-reproducible-texlive-binaries-fmt-files.hook.chroot#L52
        # note that calling faketime and fmtutil is fragile (faketime uses LD_PRELOAD, fmtutil calls /bin/sh, causing potential glibc issues on non-NixOS)
        # so we patch fmtutil to use faketime, rather than calling faketime fmtutil
        substitute "$TEXMFDIST"/scripts/texlive/fmtutil.pl fmtutil \
            --replace-fail "my \$cmdline = \"\$eng -ini " "my \$cmdline = \"faketime -f '\@$(date +'%F %T' --date=@"$SOURCE_DATE_EPOCH") x0.001' \$eng -ini "
        FORCE_SOURCE_DATE=1 TZ='' perl fmtutil --quiet --strict --sys --all 2>&1 | grep '^fmtutil' # too verbose
    fi

    do_path_adjustments

    do_tlpdb_postactions

    # remove log files to improve reproducibility
    find "$TEXMFSYSVAR" -name '*.log' -delete
}

### TeXLive::TLUtils

create_fmtutil () {
    # fmtutil.cnf created by install-tl already exists readonly in $TEXMFDIST
    # so here we need to *disable* the entries that are not in $fmtutilCnf

    local engine fmt line outFile sedExpr
    outFile="$TEXMFSYSCONFIG"/web2c/fmtutil.cnf

    nixpkgs_texlive_log "writing fmtutil.cnf to $outFile"

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
        sed -E -n -e "$sedExpr" "$TEXMFDIST"/web2c/fmtutil.cnf
        [[ -z $fmtutilCnf ]] || printf '%s' "$fmtutilCnf"
    } >"$outFile"
}

create_updmap () {
    # updmap.cfg created by install-tl already exists readonly in $TEXMFDIST
    # so here we need to *disable* the entries that are not in $updmapCfg

    local line map outFile sedExpr
    outFile="$TEXMFSYSCONFIG"/web2c/updmap.cfg

    nixpkgs_texlive_log "writing updmap.cfg to $outFile"

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
        sed -E -n -e "$sedExpr" "$TEXMFDIST"/web2c/updmap.cfg
        [[ -z $updmapCfg ]] || printf '%s' "$updmapCfg"
    } >"$outFile"
}

_create_config_files () {
    # simplified arguments
    local header="$1"
    local dest="$2"
    local prefix="$3"
    local lines="$4"
    local suffix="$5"
    if [[ -z "$header" || -e "$header" ]] ; then
        nixpkgs_texlive_log "writing ${dest##*/} to $dest"
        {
            [[ -z $prefix ]] || printf '%s\n' "$prefix"
            [[ ! -e $header ]] || cat "$header"
            [[ -z $lines ]] || printf '%s\n' "$lines"
            [[ -z $suffix ]] || printf '%s\n' "$suffix"
        } >"$dest"
    fi
}

create_language_dat () {
    _create_config_files \
        "$TEXMFDIST"/tex/generic/config/language.us \
        "$TEXMFSYSVAR"/tex/generic/config/language.dat \
        '% Generated by nixpkgs' \
        "$languageDat" \
        ''
}

create_language_def () {
    _create_config_files \
        "$TEXMFDIST"/tex/generic/config/language.us.def \
        "$TEXMFSYSVAR"/tex/generic/config/language.def \
        '' \
        "$languageDef" \
        '%%% No changes may be made beyond this point.

\uselanguage {USenglish}             %%% This MUST be the last line of the file.'
}

create_language_lua () {
    _create_config_files \
        "$TEXMFDIST"/tex/generic/config/language.us.lua \
        "$TEXMFSYSVAR"/tex/generic/config/language.dat.lua \
        '-- Generated by nixpkgs' \
        "$languageLua" \
        '}'
}

update_context_cache () {
    if [[ -x $out/bin/mtxrun ]] ; then
        nixpkgs_texlive_log "generating ConTeXt cache"

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
TEXMFROOT="$texmfroot"
TEXMFDIST="$texmfdist"
export PATH="$out/bin:$PATH"
TEXMFSYSCONFIG="$out/share/texmf-config"
TEXMFSYSVAR="$out/share/texmf-var"
export TEXMFCNF="$TEXMFSYSCONFIG/web2c"

do_postinst_stuff
