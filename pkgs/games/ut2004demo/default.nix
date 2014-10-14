{stdenv, fetchurl, xlibs, mesa}:

assert stdenv.system == "i686-linux";

let {

  raw = stdenv.mkDerivation {
    name = "ut2004-demo-3120";
    src = fetchurl {
      url = http://ftp.gameaholic.com/pub/demos/ut2004-lnx-demo-3120.run.bz2;
      sha256 = "1lravfkb1gsallqqird5dcbz42vwjg36m1qk76nmmnyyyghwqnli";
    };
    builder = ./builder.sh;
  };

  body = stdenv.mkDerivation {
    name = raw.name;
    builder = ./make-wrapper.sh;
    inherit raw mesa;
    inherit (xlibs) libX11 libXext;
  };

}

# http://mirror1.icculus.org/ut2004/ut2004-lnxpatch3204.tar.bz2
# 5f659552095b878a029b917d216d9664
