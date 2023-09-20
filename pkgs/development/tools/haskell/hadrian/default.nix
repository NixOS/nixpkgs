{ # GHC source tree to build hadrian from
  ghcSrc ? null, ghcVersion ? null
, mkDerivation, base, bytestring, Cabal, containers, directory
, extra, filepath, lib, mtl, parsec, shake, text, transformers
, unordered-containers, cryptohash-sha256, base16-bytestring
, userSettings ? null
# Whether to pass --hyperlinked-source to haddock or not. This is a custom
# workaround as we wait for this to be configurable via userSettings or similar.
# https://gitlab.haskell.org/ghc/ghc/-/issues/23625
, enableHyperlinkedSource ? true
, writeText
}:

if ghcSrc == null || ghcVersion == null
then throw "hadrian: need to specify ghcSrc and ghcVersion arguments manually"
else

mkDerivation {
  pname = "hadrian";
  version = ghcVersion;
  src = ghcSrc;
  postUnpack = ''
    sourceRoot="$sourceRoot/hadrian"
  '';
  patches = lib.optionals (!enableHyperlinkedSource) [
    ./disable-hyperlinked-source.patch
  ];
  # Overwrite UserSettings.hs with a provided custom one
  postPatch = lib.optionalString (userSettings != null) ''
    install -m644 "${writeText "UserSettings.hs" userSettings}" src/UserSettings.hs
  '';
  configureFlags = [
    # avoid QuickCheck dep which needs shared libs / TH
    "-f-selftest"
    # Building hadrian with -O1 takes quite some time with little benefit.
    # Additionally we need to recompile it on every change of UserSettings.hs.
    # See https://gitlab.haskell.org/ghc/ghc/-/merge_requests/1190
    "-O0"
  ];
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base bytestring Cabal containers directory extra filepath mtl
    parsec shake text transformers unordered-containers
  ] ++ lib.optionals (lib.versionAtLeast ghcVersion "9.7") [
    cryptohash-sha256 base16-bytestring
  ];
  description = "GHC build system";
  license = lib.licenses.bsd3;
}
