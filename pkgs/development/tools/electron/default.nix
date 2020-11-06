{ stdenv, libXScrnSaver, makeWrapper, fetchurl, wrapGAppsHook, glib, gtk3, unzip, atomEnv, libuuid, at-spi2-atk, at-spi2-core, libdrm, mesa }@args:

let
  mkElectron = import ./generic.nix args;
in
rec {

  electron = electron_10;

  electron_3 = mkElectron "3.1.13" {
    x86_64-linux = "1psmbplz6jhnnf6hmfhxbmmhn4n1dpnhzbc12pxn645xhfpk9ark";
    x86_64-darwin = "1vvjm4jifzjqvbs2kjlwg1h9p2czr2b5imjr9hld1j8nyfrzb0dx";
    i686-linux = "04i0rcp4ajp4nf4arcl5crcc7a85sf0ixqd8jx07k2b1irv4dc23";
    armv7l-linux = "1pzs2cj12xw18jwab0mb8xhndwd95lbsj5ml5xdw2mb0ip5jsvsa";
    aarch64-linux = "13pc7xn0dkb8i31vg9zplqcvb7r9r7q3inmr3419b5p9bl0687x8";
  };

  electron_4 = mkElectron "4.2.12" {
    x86_64-linux = "72c5319c92baa7101bea3254a036c0cd3bcf257f4a03a0bb153668b7292ee2dd";
    x86_64-darwin = "89b0e16bb9b7072ed7ed1906fccd08540acdd9f42dd8a29c97fa17d811b8c5e5";
    i686-linux = "bf96b1736141737bb064e48bdb543302fd259de634b1790b7cf930525f47859f";
    armv7l-linux = "2d970b3020627e5381fd4916dd8fa50ca9556202c118ab4cba09c293960689e9";
    aarch64-linux = "938b7cc5f917247a120920df30374f86414b0c06f9f3dc7ab02be1cadc944e55";
  };

  electron_5 = mkElectron "5.0.13" {
    x86_64-linux = "8ded43241c4b7a6f04f2ff21c75ae10e4e6db1794e8b1b4f7656c0ed21667f8f";
    x86_64-darwin = "589834815fb9667b3c1c1aa6ccbd87d50e5660ecb430f6b475168b772b9857cd";
    i686-linux = "ccf4a5ed226928a30bd3ea830913d99853abb089bd4a6299ffa9fa0daa8d026a";
    armv7l-linux = "96ad83802bc61d87bb952027d49e5dd297f58e4493e66e393b26e51e09065add";
    aarch64-linux = "01f0fd313b060fb28a1022d68fb224d415fa22986e2a8f4aded6424b65e35add";
  };

  electron_6 = mkElectron "6.1.12" {
    x86_64-linux = "dc628216588a896e72991d46071d06ef11aed2cdeca18d11d472c29cfbf12349";
    x86_64-darwin = "6c7244319fdfb90899a48ffd0f426e36dba7c3fc5e29b28a4d29fdca7fb924d3";
    i686-linux = "4e61dc4aed1c1b933b233e02833948f3b17f81f3444f02e9108a78c0540159ab";
    armv7l-linux = "06071b4dc59a6773ff604550ed9e7a7ae8722b5343cbb5d4b94942fe537211dc";
    aarch64-linux = "4ae23b75be821044f7e5878fe8e56ab3109cbd403ecd88221effa6abf850260b";
  };

  electron_7 = mkElectron "7.3.3" {
    x86_64-linux = "a947228a859149bec5bd937f9f3c03eb0aa4d78cfe4dfa9aead60d3646a357f9";
    x86_64-darwin = "e081436abef52212065f560ea6add1c0cd13d287a1b3cc76b28d2762f7651a4e";
    i686-linux = "5fb756900af43a9daa6c63ccd0ac4752f5a479b8c6ae576323fd925dbe5ecbf5";
    armv7l-linux = "830678f6db27fa4852cf456d8b2828a3e4e3c63fe2bced6b358eae88d1063793";
    aarch64-linux = "03d06120464c353068e2ac6c40f89eedffd6b5b3c4c96efdb406c96a6136a066";
  };

  electron_8 = mkElectron "8.5.2" {
    x86_64-linux = "c5b8c95b410436066b06165e9759b31336c907268339433db4f8610ccf644a51";
    x86_64-darwin = "079d951a28cfb7d1e0d3660e0fcb2dab85bd9e9f6848df5a06a7ac88ab3aa14c";
    i686-linux = "0d108ac2420a437100f7a8d06aa019cd8138da4372fb94039b6d23c6253a6aea";
    armv7l-linux = "f06ed475d1b206c3aa31e768add3517a64aabce5e2946e4d9707e615e6f398c0";
    aarch64-linux = "e9765584bbedad8a806f96ac1381c114a357fdbed8c67573decefde2d15d9cd7";
  };

  electron_9 = mkElectron "9.3.3" {
    x86_64-linux = "17f4db5e040ea20ce89d1d492ac575ed0b9ba451ef9cb0e8cd50918505c85243";
    x86_64-darwin = "bb6188178ed1250ddaf29a2f232758c0f7878f1541ddb2ae2a0d20298599c7f4";
    i686-linux = "e413b0879247b32bfbcc114e8d49109267137b2ece97db13eaf0ce3ac6187881";
    armv7l-linux = "313abeb91efbc29d4f807a01937640580940a5fb2699c70b1c303b184ac7bec4";
    aarch64-linux = "263eb89ccb47920baef43898d373531d369d2adc8b2f9e5ebc6429fe44b2fd5a";
  };

  electron_10 = mkElectron "10.1.5" {
    x86_64-linux = "9db65dfe26d4fa9524b3005c6002d858ab256722cefb6a058de8e72e2d5c4083";
    x86_64-darwin = "30dc5d5a913c38c6ae7fa6913b1a907545f0230157efc066e2d5a7affd26cd1e";
    i686-linux = "bf8e1731e8b9b972c9054964b219d9b1b6baae9612afc8a5edf3503b815dd8c3";
    armv7l-linux = "e270eab1a87283d7ae25c8127d904a52f130d53cc399bd288af7f99563273f33";
    aarch64-linux = "03fa2418472f762377149fdd45d1e6ff0a324be3eb1b04e58c63d41df3dd0f16";
  };
}
