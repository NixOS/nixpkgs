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

  electron_9 = mkElectron "9.3.4" {
    x86_64-linux = "4791d854886cba4f461f37db41e6be1fbd8e41e7da01f215324f1fe19ad18ebf";
    x86_64-darwin = "d6878093683ef901727d3b557f1ac928de86b7fffd2abd2c8315d0a9cfe20375";
    i686-linux = "bd3cc9ddab3a9e54499f98e68b12f0aa30554c6527e1434b78743041aaae9417";
    armv7l-linux = "1b175fe3e83494015714afb298b756187053dd84604746c60649a2abbb49ee36";
    aarch64-linux = "626e4f79e9de57aef9e33f9788bf64375095ef43089eda6c6a87835ba58a7aa3";
  };

  electron_10 = mkElectron "10.1.6" {
    x86_64-linux = "d538ed7bb632d213a4b88d13bb038de65b85ae7b28a574c9efac7dc5a502ebbf";
    x86_64-darwin = "7f24c666cc59935a49e5b82b4d4c1d008e4d6fac49c78d0645596f2cc8c7218d";
    i686-linux = "009bbee26ddbf748b33588714ccc565257ff697cde2110e6b6547e3f510da85e";
    armv7l-linux = "e8999af21f7e58c4dc27594cd75438e1a5922d3cea62be63c927d29cba120951";
    aarch64-linux = "b906998ddaf96da94a43bbe38108d83250846222de2727c268ad50f24c55f0da";
  };

  electron_11 = mkElectron "11.0.2" {
    x86_64-linux = "a6e4f789d99e2ed879b48e7cbca2051805c3727360074edfe903231756eb5636";
    x86_64-darwin = "4a562646440c3f4fa1ec4bbdb238da420158e19f294a0fbcdf32004465dbd516";
    i686-linux = "ffcb2e40f98ee521ac50aa849cd911e62dae8a610bcca3f6d393b3f8d9bb85d8";
    armv7l-linux = "7552f0c2aad05844ceacaaf13588b06b16e9aadd947084e8249214b24d1da38d";
    aarch64-linux = "56b5ae4a33a9aa666fbe1463c7780d4c737c84119eff77d403fb969e8ff90ce0";
  };
}
