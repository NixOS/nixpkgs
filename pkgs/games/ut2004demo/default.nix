{stdenv, fetchurl, xorg, mesa}:

assert stdenv.system == "i686-linux";

let {

  raw = stdenv.mkDerivation {
    name = "ut2004-demo-3120";
    src = fetchurl {
      urls = [
        ("http://store.node-10.ds-servers.com/file/BcFLgoIgAADQA7kw0qZctDAF+4cj"
          + "mbnDMFOJTAyM0-cejkEIuDvQ6Uv9ZbvcWMnRmXXxhA0LyvzoKdvsnXne0D1DGTLiR0"
          + "I1CmM2M-E5ryH-tD3yweCXyNyH1WGI3Wh09ja29mHtzGF1rxEyhRfQ7ggCKdfCrhvz"
          + "H9oTJXSCAtGuSKdVDhe6tNtrqa151MIircZtRLPxQcGmJ+n3-iUeWYgHuqbmrK4ur7"
          + "Qcy6QrAhYa+e5jcfYjgPF3VGsw4qx+0ilxJUCiuYCX2H8A6X3rxJILa26w3O425W2G"
          + "kHPiQWrhFT8cIOyqSr8+dMO5Xi5-/ut2004-lnx-demo-3120.run.bz2")
        http://ftp.gameaholic.com/pub/demos/ut2004-lnx-demo-3120.run.bz2
      ];
      sha256 = "1lravfkb1gsallqqird5dcbz42vwjg36m1qk76nmmnyyyghwqnli";
    };
    builder = ./builder.sh;
  };

  body = stdenv.mkDerivation {
    name = raw.name;
    builder = ./make-wrapper.sh;
    inherit raw mesa;
    inherit (xorg) libX11 libXext;
  };

}

# http://mirror1.icculus.org/ut2004/ut2004-lnxpatch3204.tar.bz2
# 5f659552095b878a029b917d216d9664
