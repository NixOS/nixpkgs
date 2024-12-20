{
  lib,
  fetchFromGitHub,
  runCommand,
  yallback,
  yara,
}:

/*
  TODO/CAUTION:

  I don't want to discourage use, but I'm not sure how stable
  the API is. Have fun, but be prepared to track changes! :)

  For _now_, binlore is basically a thin wrapper around
  `<invoke yara> | <postprocess with yallback>` with support
  for running it on a derivation, saving the result in the
  store, and aggregating results from a set of packages.

  In the longer term, I suspect there are more uses for this
  general pattern (i.e., run some analysis tool that produces
  a deterministic output and cache the result per package...).

  I'm not sure how that'll look and if it'll be the case that
  binlore automatically collects all of them, or if you'll be
  configuring which "kind(s)" of lore it generates. Nailing
  that down will almost certainly mean reworking the API.
*/

let
  src = fetchFromGitHub {
    owner = "abathur";
    repo = "binlore";
    rev = "v0.3.0";
    hash = "sha256-4Fs6HThfDhKRskuDJx2+hucl8crMRm10K6949JdIwPY=";
  };
  /*
    binlore has one one more yallbacks responsible for
    routing the appropriate lore to a named file in the
    appropriate format. At some point I might try to do
    something fancy with this, but for now the answer to
    *all* questions about the lore are: the bare minimum
    to get resholve over the next feature hump in time to
    hopefully slip this feature in before the branch-off.
  */
  # TODO: feeling really uninspired on the API
  loreDef = {
    # YARA rule file
    rules = (src + "/execers.yar");
    # output filenames; "types" of lore
    types = [
      "execers"
      "wrappers"
    ];
    # shell rule callbacks; see github.com/abathur/yallback
    yallback = (src + "/execers.yall");
    # TODO:
    # - echo for debug, can be removed at some point
    # - I really just wanted to put the bit after the pipe
    #   in here, but I'm erring on the side of flexibility
    #   since this form will make it easier to pilot other
    #   uses of binlore.
    callback = lore: drv: ''
      if [[ -d "${drv}/bin" ]] || [[ -d "${drv}/lib" ]] || [[ -d "${drv}/libexec" ]]; then
        echo generating binlore for $drv by running:
        echo "${yara}/bin/yara --scan-list --recursive ${lore.rules} <(printf '%s\n' ${drv}/{bin,lib,libexec}) | ${yallback}/bin/yallback ${lore.yallback}"
      else
        echo "failed to generate binlore for $drv (none of ${drv}/{bin,lib,libexec} exist)"
      fi

      if [[ -d "${drv}/bin" ]] || [[ -d "${drv}/lib" ]] || [[ -d "${drv}/libexec" ]]; then
        ${yara}/bin/yara --scan-list --recursive ${lore.rules} <(printf '%s\n' ${drv}/{bin,lib,libexec}) | ${yallback}/bin/yallback ${lore.yallback}
      fi
    '';
  };

in
rec {
  /*
    Output a directory containing lore for multiple drvs.

    This will `make` lore for drv in drvs and then combine lore
    of the same type across all packages into a single file.

    When drvs are also specified in the strip argument, corresponding
    lore is made relative by stripping the path of each drv from
    matching entries. (This is mainly useful in a build process that
    uses a chain of two or more derivations where the output of one
    is the source for the next. See resholve for an example.)
  */
  collect =
    {
      lore ? loreDef,
      drvs,
      strip ? [ ],
    }:
    (runCommand "more-binlore" { } ''
      mkdir $out
      for lorefile in ${toString lore.types}; do
        cat ${
          lib.concatMapStrings (x: x + "/$lorefile ") (
            map (make lore) (map lib.getBin (builtins.filter lib.isDerivation drvs))
          )
        } > $out/$lorefile
        substituteInPlace $out/$lorefile ${lib.concatMapStrings (x: "--replace-quiet '${x}/' '' ") strip}
      done
    '');

  /*
    Output a directory containing lore for a single drv.

    This produces lore for the derivation (via lore.callback) and
    appends any lore that the derivation itself wrote to nix-support
    or which was overridden in drv.binlore.<outputName> (passthru).

    > *Note*: Since the passthru is attached to all outputs, binlore
    > is an attrset namespaced by outputName to support packages with
    > executables in more than one output.

    Since the last entry wins, the effective priority is:
    drv.binlore.<outputName> > $drv/nix-support > lore generated here by callback
  */
  make =
    lore: drv:
    runCommand "${drv.name}-binlore"
      {
        drv = drv;
      }
      (
        ''
          mkdir $out
          touch $out/{${builtins.concatStringsSep "," lore.types}}

          ${lore.callback lore drv}
        ''
        +
          # append lore from package's $out and drv.binlore.${drv.outputName} (last entry wins)
          ''
            for lore_type in ${builtins.toString lore.types}; do
              if [[ -f "${drv}/nix-support/$lore_type" ]]; then
                cat "${drv}/nix-support/$lore_type" >> "$out/$lore_type"
              fi
          ''
        +
          lib.optionalString (builtins.hasAttr "binlore" drv && builtins.hasAttr drv.outputName drv.binlore)
            ''
              if [[ -f "${drv.binlore."${drv.outputName}"}/$lore_type" ]]; then
                cat "${drv.binlore."${drv.outputName}"}/$lore_type" >> "$out/$lore_type"
              fi
            ''
        + ''
          done

          echo binlore for $drv written to $out
        ''
      );

  /*
    Utility function for creating override lore for drv.

    We normally attach this lore to `drv.passthru.binlore.<outputName>`.

    > *Notes*:
    > - Since the passthru is attached to all outputs, binlore is an
    >   attrset namespaced by outputName to support packages with
    >   executables in more than one output. You'll generally just use
    >   `out` or `bin`.
    > - We can reconsider the passthru attr name if someone adds
    >   a new lore provider. We settled on `.binlore` for now to make it
    >   easier for people to figure out what this is for.

    The lore argument should be a Shell script (string) that generates
    the necessary lore. You can use arbitrary Shell, but this function
    includes a shell DSL you can use to declare/generate lore in most
    cases. It has the following functions:

    - `execer <verdict> [<path>...]`
    - `wrapper <wrapper_path> <original_path>`

    Writing every override explicitly in a Nix list would be tedious
    for large packages, but this small shell DSL enables us to express
    many overrides efficiently via pathname expansion/globbing.

    Here's a very general example of both functions:

    passthru.binlore.out = binlore.synthesize finalAttrs.finalPackage ''
      execer can bin/hello bin/{a,b,c}
      wrapper bin/hello bin/.hello-wrapped
    '';

    And here's a specific example of how pathname expansion enables us
    to express lore for the single-binary variant of coreutils while
    being both explicit and (somewhat) efficient:

    passthru = {} // optionalAttrs (singleBinary != false) {
      binlore.out = binlore.synthesize coreutils ''
        execer can bin/{chroot,env,install,nice,nohup,runcon,sort,split,stdbuf,timeout}
        execer cannot bin/{[,b2sum,base32,base64,basename,basenc,cat,chcon,chgrp,chmod,chown,cksum,comm,cp,csplit,cut,date,dd,df,dir,dircolors,dirname,du,echo,expand,expr,factor,false,fmt,fold,groups,head,hostid,id,join,kill,link,ln,logname,ls,md5sum,mkdir,mkfifo,mknod,mktemp,mv,nl,nproc,numfmt,od,paste,pathchk,pinky,pr,printenv,printf,ptx,pwd,readlink,realpath,rm,rmdir,seq,sha1sum,sha224sum,sha256sum,sha384sum,sha512sum,shred,shuf,sleep,stat,stty,sum,sync,tac,tail,tee,test,touch,tr,true,truncate,tsort,tty,uname,unexpand,uniq,unlink,uptime,users,vdir,wc,who,whoami,yes}
      '';
    };

    Caution: Be thoughtful about using a bare wildcard (*) glob here.
    We should generally override lore only when a human understands if
    the executable will exec arbitrary user-passed executables. A bare
    glob can match new executables added in future package versions
    before anyone can audit them.
  */
  synthesize =
    drv: loreSynthesizingScript:
    runCommand "${drv.name}-lore-override"
      {
        drv = drv;
      }
      (
        ''
          execer(){
            local verdict="$1"

            shift

            for path in "$@"; do
              if [[ -f "$PWD/$path" ]]; then
                echo "$verdict:$PWD/$path"
              else
                echo "error: Tried to synthesize execer lore for missing file: $PWD/$path" >&2
                exit 2
              fi
            done
          } >> $out/execers

          wrapper(){
            local wrapper="$1"
            local original="$2"

            if [[ ! -f "$wrapper" ]]; then
              echo "error: Tried to synthesize wrapper lore for missing wrapper: $PWD/$wrapper" >&2
              exit 2
            fi

            if [[ ! -f "$original" ]]; then
              echo "error: Tried to synthesize wrapper lore for missing original: $PWD/$original" >&2
              exit 2
            fi

            echo "$PWD/$wrapper:$PWD/$original"

          } >> $out/wrappers

          mkdir $out

          # lore override commands are relative to the drv root
          cd $drv

        ''
        + loreSynthesizingScript
      );
}
