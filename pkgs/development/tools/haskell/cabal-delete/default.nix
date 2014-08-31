{ cabal, fetchgit, bytestring ? null, containers ? null, directory ? null,
  filepath, process ? null, attoparsec, ghcPaths, transformers }:

let
  tag = "0.5.2.0";
in

cabal.mkDerivation (self: {
  pname = "cabal-delete";
  version = "${tag}";
  src = fetchgit {
    url = git://github.com/iquiw/cabal-delete.git;
    rev = "refs/tags/v${tag}";
    sha256 = "1ap319isjg8bafm4jz2krfwvvg11hj5yk0g99a3l1a3a36hpdgzw";
  };
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
      bytestring
      containers
      directory
      filepath
      process
      attoparsec
      ghcPaths
      transformers
  ];
  meta = {
    homepage = "https://github.com/iquiw/cabal-delete";
    description = "Uninstall packages installed by cabal";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
    broken = true;
  };
})
