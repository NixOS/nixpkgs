args: with args; {
  # optional srcDir
  annotatedWithSourceAndTagInfo = x : (x ? passthru && x.passthru ? sourceWithTags 
                                      || x ? meta && x.meta ? sourceWithTags );
  # hack because passthru doesn't work the way I'd expect. Don't have time to spend on this right now
  # that's why I'm abusing meta for the same purpose in ghcsAndLibs
  sourceWithTagsFromDerivation = x : if (x ? passthru && x.passthru ? sourceWithTags ) then x.passthru.sourceWithTags
                                     else if (x ? meta && x.meta ? sourceWithTags ) then x.meta.sourceWithTags
                                       else null;

  # createTagFiles =  [ { name  = "my_tag_name_without_suffix", tagCmd = "ctags -R . -o \$TAG_FILE"; } ]
  # tag command must create file named $TAG_FILE
  sourceWithTagsDerivation = {name, src, srcDir ? ".", tagSuffix ? "_tags", createTagFiles ? []} :  
    stdenv.mkDerivation {
    phases = "unpackPhase buildPhase";
    inherit src srcDir tagSuffix;
    name = "${name}-source-with-tags";
    buildInputs = [ unzip ];
    # using separate tag directory so that you don't have to glob that much files when starting your editor
    # is this a good choice?
    buildPhase =
      lib.defineShList "sh_list_names" (lib.catAttrs "name" createTagFiles)
    + lib.defineShList "sh_list_cmds" (lib.catAttrs "tagCmd" createTagFiles)
    + "SRC_DEST=\$out/src/\$name
      ensureDir \$SRC_DEST
      cp -r \$srcDir \$SRC_DEST
      cd \$SRC_DEST
      for a in `seq 0 \${#sh_list}`; do
          TAG_FILE=\"\$SRC_DEST/\"\${sh_list_names[$a]}$tagSuffix
          cmd=\"\${sh_list_cmds[$a]}\"
          echo running tag cmd \"$cmd\" in `pwd`
          eval \"\$cmd\";
          TAG_FILES=\"\$TAG_FILES\${TAG_FILES:+:}\$TAG_FILE\"
       done
       echo \"TAG_FILES=\\\"\\\$TAG_FILES\\\${TAG_FILES:+:}$TAG_FILES\\\"\" >> $out/nix-support
    ";
  };
  # example usage
  #testSourceWithTags = sourceWithTagsDerivation (ghc68extraLibs ghcsAndLibs.ghc68).happs_server_darcs.passthru.sourceWithTags;


  # creates annotated derivation (comments see above)
  addHasktagsTaggingInfo = deriv : deriv // {
      passthru = {
        sourceWithTags = {
         inherit (deriv) src;
         srcDir = if deriv ? srcDir then deriv.srcDir else ".";
         name = deriv.name + "-src-with-tags";
         createTagFiles = [
               { name = "${deriv.name}_haskell";
                 # tagCmd = "${toString ghcsAndLibs.ghc68.ghc}/bin/hasktags --ignore-close-implementation --ctags `find . -type f -name \"*.*hs\"`; sort tags > \$TAG_FILE"; }
                 tagCmd = "${toString hasktags}/bin/hasktags-modified --ignore-close-implementation --ctags `find . -type f -name \"*.*hs\"`; sort tags > \$TAG_FILE"; }
          ];
       };
    };
  };


  addCTaggingInfo = deriv :
    deriv // { 
      passthru = {
        sourceWithTags = {
         inherit (deriv) src;
         name = "${deriv.name}-source-ctags";
         createTagFiles = [
               { inherit  (deriv) name;
                 tagCmd = "${toString ctags}/bin/ctags --sort=yes -o \$TAG_FILE -R ."; }
          ];
        };
  }; };
}
/*
experimental
idea:
a) Attach some information to a nexpression telling how to create a tag file which can then be used within your favourite editor
   Do this in a way not affecting the expression (using passthru or meta which is ignored when calculating the hash)
   implementations: addCTaggingInfo (C / C++) and addHasktagsTaggingInfo (Haskell)
b) use sourceWithTagsDerivation function to create a derivation installing the source along with the generated tag files
   so that you can use them easily witihn your favourite text editor
*/
