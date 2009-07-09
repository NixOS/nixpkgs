{cabal, binary}:

cabal.mkDerivation (self : {
  pname = "tar";
  version = "0.3.1.0";
  name = self.fname;
  sha256 = "1n16sq5y7x30r1k7ydxmncn9x2nx3diildzyfxjy2b8drxp4jr03";
  extraBuildInputs = [binary];
  meta = {
    description = "tar wrapper";
  };
})
