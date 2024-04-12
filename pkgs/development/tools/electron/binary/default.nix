{ callPackage }:

let
  mkElectron = callPackage ./generic.nix { };
in
rec {
  electron-bin = electron_29-bin;

  electron_24-bin = mkElectron "24.8.6" {
    armv7l-linux = "8f46901667a904a62df7043991f20dc1c2a00370a42159976855458562cda8fc";
    aarch64-linux = "599e78a3a8127828ea3fa444927e7e51035dba9811ce0d81d59ad9b0bd02b4f6";
    x86_64-linux = "61e87bbd361da101c6a8363cc9c1f8b8b51db61b076cf495d3f4424303265a96";
    x86_64-darwin = "067ce05d628b44e1393369c506268915081ac9d96c0973d367262c71dcd91078";
    aarch64-darwin = "d9093e6928b2247336b3f0811e4f66c4ae50a719ec9399c393ac9556c8e56cee";
    headers = "009p1ffh2cyn98fcmprrjzq79jysp7h565v4f54wvjxjsq2nkr97";
  };

  electron_27-bin = mkElectron "27.3.10" {
    armv7l-linux = "bb739ce18a9e09225e8e0e1889cf1ab35fefda4ec7c2b60bdda271e58c921271";
    aarch64-linux = "f1783e222074de33fea2188a86499d6a9d8b1aceec3bbd85a17913817a5bd356";
    x86_64-linux = "dcfe17763071f1ec694155176f9156d625e6a69ccc32253b6576ca65111783c0";
    x86_64-darwin = "5f469975f5ed68001dedc0383b94562c0a29e05b885427f20187625251cb83cb";
    aarch64-darwin = "cb0e524b14f0f882a61cdcc46d7f3563ce115158501caaf2e8642f647c1eed6d";
    headers = "12in54rg4dr8lh5dm9xx00w6cvbzgnylq7hjp2jwbj339xsgnqjz";
  };

  electron_28-bin = mkElectron "28.3.0" {
    armv7l-linux = "aa74e7240929ebfa817d03e025e117f7a0600c99e6ad9bc339eaf22b0144a71c";
    aarch64-linux = "9ec29245bcbbd0007029b4a3f7976b209968dbaa6443406afbf208b1a5abf094";
    x86_64-linux = "e5003391ffc5161f6d9987ed29fa97532142544326f15fbf90ee43daabeba639";
    x86_64-darwin = "7d6a0f6a7ec606d1caa0e63a99e4c6103a3fedb6e05735f81a03aa8da099a420";
    aarch64-darwin = "a0eb07c006b593be8f76f7f6ad7cb8ac619ec173d341ad4c3ca5e52b38dab8b8";
    headers = "12z94fz4zyypjkjx5l8n0qxd7r5jsny19i4ray60mn5cd7j019z8";
  };

  electron_29-bin = mkElectron "29.3.0" {
    armv7l-linux = "51a8b2d67ae58b01919d6eb9e8eef255cd4bb3475b3acaf58ed1b8dc2448f206";
    aarch64-linux = "bd74743eb03a77f40b65739b9ca751af264c6f428e16728d7e0332a4c94789a9";
    x86_64-linux = "7274fe2bbb2e3b71f8fc084921e22d10e529220d380a354827b274f9567261da";
    x86_64-darwin = "88873a315ddd2a70b82e83f2cb7495c0d9d7c7fb5c9ad14fcfee16af4ab89d5e";
    aarch64-darwin = "b3145bbd45007918c2365b1df59a35b4d0636222cd43eea4803580de36b9a17d";
    headers = "1smvjlgdp3ailmh0fvxj96p7cnvls19w7kdwn62v1s3xpl84b915";
  };
}
