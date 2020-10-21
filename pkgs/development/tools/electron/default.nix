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

  electron_8 = mkElectron "8.5.1" {
    x86_64-linux = "e58bf26ba52e43de77115b6e6844eba8a8cec2ac8aae500cf48fe862014202d9";
    x86_64-darwin = "cf0d42ecde7ca374ddf1b440aaaf441e16a02890112fcbffc03f37f8ec3b1958";
    i686-linux = "4c7ff6225b1ac4b710c454072d9fb8c04a66bb0353e7d6cffb89bcf6d4458d81";
    armv7l-linux = "13afd8b2e36eb8d1582687e16fac5394d6d3b9734d73f94d0d6ef843ba14cec2";
    aarch64-linux = "ff39e5e0e644cbf4ff1d29fc25e94b9eced7ea45d787d1b86fa4e50513336b7b";
  };

  electron_9 = mkElectron "9.3.0" {
    x86_64-linux = "0c34fa1dbf7708bd4a3f08fde50eafb9903b1c467104dca3e3ced5e7f764b302";
    x86_64-darwin = "25057470c2f3a1c40fa1c25086256041fa70419378fa3d41eeb805ebd3919b20";
    i686-linux = "ea09d10e496450d2d7bb7a37cab7124cc5484117dd7d7d6c4106586ff675d1d5";
    armv7l-linux = "a8b46d6c98546d605a02850c906408dc11104e8ee4366c3d8a956896fafdfcd3";
    aarch64-linux = "791d898d02e45975657ed15f2d83af31d5688e7db0075a6e20021db3420eb320";
  };

  electron_10 = mkElectron "10.1.1" {
    x86_64-linux = "4147e88bdbec6893bf9927f0d4f3dd090d26705f5b7f688223bc65253a8b0220";
    x86_64-darwin = "5b6814ae1064cc337efcdb2ad01ab9daa003a6a1d6e05d79288ede0a3665b991";
    i686-linux = "d29682b7ea44dcdca5e7265bd1e28046275295a9ac23982af3d216a7f47a7a57";
    armv7l-linux = "341a2eacb0381c1f409b8e28cf2c0fe6f75a61410614baf80309f51dd4201a34";
    aarch64-linux = "d5e5b069f3173ed89f4cca7e9723f28a5f7a720637b7addac02972c5db042b6c";
  };
}
