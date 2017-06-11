{ lib, stdenv, callPackage, runCommand, ruby }@defs:

{
  name
  # gemdir is the location of the Gemfile{,.lock} and gemset.nix; usually ./.
, gemdir
  # Exes is the list of executables provided by the gems in the Gemfile
, exes ? []
  # Scripts are ruby programs depend on gems in the Gemfile (e.g. scripts/rails)
, scripts ? []
, ruby ? defs.ruby
, gemfile ? null
, lockfile ? null
, gemset ? null
, preferLocalBuild ? false
, allowSubstitutes ? false
, meta ? {}
, postBuild ? ""
}@args:

let
  basicEnv = (callPackage ../bundled-common {}) args;

  cmdArgs = removeAttrs args [ "name" "postBuild" ]
  // { inherit preferLocalBuild allowSubstitutes; }; # pass the defaults
in
   runCommand name cmdArgs ''
    mkdir -p $out/bin; cd $out;
      ${(lib.concatMapStrings (x: "ln -s '${basicEnv}/bin/${x}' '${x}';\n") exes)}
      ${(lib.concatMapStrings (s: "makeWrapper $out/bin/$(basename ${s}) $srcdir/${s} " +
              "--set BUNDLE_GEMFILE ${basicEnv.confFiles}/Gemfile "+
              "--set BUNDLE_PATH ${basicEnv}/${ruby.gemPath} "+
              "--set BUNDLE_FROZEN 1 "+
              "--set GEM_HOME ${basicEnv}/${ruby.gemPath} "+
              "--set GEM_PATH ${basicEnv}/${ruby.gemPath} "+
              "--run \"cd $srcdir\";\n") scripts)}
    ${postBuild}
  ''
