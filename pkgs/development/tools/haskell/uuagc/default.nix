{cabal, uulib}:

cabal.mkDerivation (self : {
  pname = "uuagc";
  version = "0.9.7";
  name = self.fname;
  sha256 = "7479ddbc8dc4b04cae278a942a50d7d76f06011aca06c56bcd26bdeba6eeb2d6";
  extraBuildInputs = [uulib];
  meta = {
    description = "Attribute Grammar System of Universiteit Utrecht";
  };
})
