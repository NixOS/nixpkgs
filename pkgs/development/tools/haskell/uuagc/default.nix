{cabal, uulib}:

cabal.mkDerivation (self : {
  pname = "uuagc";
  version = "0.9.6";
  name = self.fname;
  sha256 = "10e148bdf052e9a80e52c54a94314df9d1772e68416e5dfac289c47fd1ba8558";
  extraBuildInputs = [uulib];
  meta = {
    description = "Attribute Grammar System of Universiteit Utrecht";
  };
})
