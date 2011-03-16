{cabal, mtl, network, time}:

cabal.mkDerivation (self : {
  pname = "hslogger";
  version = "1.1.4";
  sha256 = "0858jbkjda7ccjzxjnlp2ng1jyvfsa1jhd45vr9bbhsr8qwrdky7";
  propagatedBuildInputs = [ mtl time network ];
  meta = {
    description = "Versatile logging framework";
  };
})
