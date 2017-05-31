{ stdenv }@defs:

{
  name
, gemdir
, exes ? []
, scripts ? []
, postBuild
}@args:

let
  basicEnv = (callPackage ../bundled-common {}) (args // { inherit name gemdir;
    gemfile = gemfile';
    lockfile  = lockfile';
    gemset = gemset';
  });

  args = removeAttrs args_ [ "name" "postBuild" ]
  // { inherit preferLocalBuild allowSubstitutes; }; # pass the defaults
in
   runCommand name args ''
    mkdir -p $out; cd $out;
      ${(lib.concatMapStrings (x: "ln -s '${basicEnv}/bin/${x}' '${x}';\n") exes)}
      ${(lib.concatMapStrings (s: "makeWrapper ${out}/bin/$(basename ${s}) $srcdir/${s} " +
              "--set BUNDLE_GEMFILE ${basicEnv.confFiles}/Gemfile "+
              "--set BUNDLE_PATH ${basicEnv}/${ruby.gemPath} "+
              "--set BUNDLE_FROZEN 1 "+
              "--set GEM_HOME ${basicEnv}/${ruby.gemPath} "+
              "--set GEM_PATH ${basicEnv}/${ruby.gemPath} "+
              "--run \"cd $srcdir\";\n") scripts)}
    ${postBuild}
  ''
