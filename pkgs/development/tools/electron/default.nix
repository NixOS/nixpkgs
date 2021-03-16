{ stdenv
, libXScrnSaver
, makeWrapper
, fetchurl
, wrapGAppsHook
, glib
, gtk3
, unzip
, atomEnv
, libuuid
, at-spi2-atk
, at-spi2-core
, libdrm
, mesa
, libxkbcommon
}@args:

let
  mkElectron = import ./generic.nix args;
in
rec {

  electron = electron_11;

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

  electron_8 = mkElectron "8.5.5" {
    x86_64-linux = "8058442ab4a18d73ca644d4a6f001e374c3736bc7e37db0275c29011681f1f22";
    x86_64-darwin = "02bb9f672c063b23782bee6e336864609eed72cffeeea875a3b43c868c6bd8b3";
    i686-linux = "c8ee6c3d86576fe7546fb31b9318cb55a9cd23c220357a567d1cb4bf1b8d7f74";
    armv7l-linux = "0130d1fcd741552d2823bc8166eae9f8fc9f17cd7c0b2a7a5889d753006c0874";
    aarch64-linux = "ca16d8f82b3cb47716dc9db273681e9b7cd79df39894a923929c99dd713c45f5";
  };

  electron_9 = mkElectron "9.4.3" {
    x86_64-linux = "7744ec8af6512e569d600d7fd8e9105d3ca5ac7b6f54390dd553edbd7816289f";
    x86_64-darwin = "68c67a32f149618d629eb4a8a8044b98dc6ceedc16d46ff20782fcccad72fc44";
    i686-linux = "904955ee8365b95439fb4643844ac868b59525ed230a76c8e0395c0aa5719813";
    armv7l-linux = "5cfb3ae97a75d33d4b102d75944610dd56a566ee98186a030eb5bdbbd3d76323";
    aarch64-linux = "8afa647e4b5b1e290d5d852c7420e82916ba740e3e5576599076dc139cd1d556";
    headers = "0712160j1yvl9fmj2vm9lznkwnmji1hjzyicb4vis52lbrwx820l";
  };

  electron_10 = mkElectron "10.3.2" {
    x86_64-linux = "e28748c813ddc69c611a47961d68ae2dc3761f547c509d9ce2c56c2c6eadc9a2";
    x86_64-darwin = "3120ae3eab94d9102003f6fa2dc833a0629295c7ec0e154b35f61116d55a4954";
    i686-linux = "13f42ad6ea0fa41553b8f50323d0baaa29272220a2e81ca5293ad4439cda1d79";
    armv7l-linux = "0e571f63697b8985782175af07bdd7069886195d9ccd7fc5c04578b4144ea922";
    aarch64-linux = "173551fa6cd3ca1fb52fab3bd3e7f0ffd3e4758e78a5174e6d636a45a282ab8f";
    headers = "00x71b18prc55pv3sykbzpmkxf8yjzf2cdnlqif993jab8fbwmqn";
  };

  electron_11 = mkElectron "11.2.1" {
    x86_64-linux = "607d9d58c9a3b5c36461acc6bbe473bc604eee42a55c2c617ac46d095cf98abb";
    x86_64-darwin = "39d95668a3ea04bdc652ff9e2889c7a88f638534420e8e256679cbf4b7658a65";
    i686-linux = "59f226133d01fb6acf86fe98907964f79dcf2902054e5c4c9c4ff84a3ea88f4a";
    armv7l-linux = "85051d8eacf04aeec3dd74e46e7888d01bd4e6caf7ec2001122a1f3e11db44ee";
    aarch64-linux = "8aa9be5d6c139386390bad64f78b95756206a40fe4982fc9f199b67a7d06bec5";
    headers = "12sy8zzb0z654b85c5l1j8762nhwmkim1pbz1y3qzgbzvpbd5arq";
  };
}
