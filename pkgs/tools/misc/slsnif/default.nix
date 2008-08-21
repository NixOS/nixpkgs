args:
args.stdenv.mkDerivation {
  name = "slsnif-0.4.4";

  src = args.fetchurl {
    url = mirror://sourceforge/slsnif/slsnif-0.4.4.tar.gz;
    sha256 = "0gn8c5hj8m3sywpwdgn6w5xl4rzsvg0z7d2w8dxi6p152j5b0pii";
  };

  buildInputs =(with args; []);

  meta = { 
      description = "serial line sniffer";
      homepage = http://slsnif.sourceforge.net/;
      license = "GPLv2";
  };
}
