{ lib, stdenv
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
, libappindicator-gtk3
, libxshmfence
}@args:

let
  mkElectron = import ./generic.nix args;
in
rec {

  electron = electron_12;

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
    headers = "0943wc2874s58pkpzm1l55ycgbhv60m62r8aix88gl45i6zngb2g";
  };

  electron_5 = mkElectron "5.0.13" {
    x86_64-linux = "8ded43241c4b7a6f04f2ff21c75ae10e4e6db1794e8b1b4f7656c0ed21667f8f";
    x86_64-darwin = "589834815fb9667b3c1c1aa6ccbd87d50e5660ecb430f6b475168b772b9857cd";
    i686-linux = "ccf4a5ed226928a30bd3ea830913d99853abb089bd4a6299ffa9fa0daa8d026a";
    armv7l-linux = "96ad83802bc61d87bb952027d49e5dd297f58e4493e66e393b26e51e09065add";
    aarch64-linux = "01f0fd313b060fb28a1022d68fb224d415fa22986e2a8f4aded6424b65e35add";
    headers = "0najajj1kjj0rbqzjvk9ipq0pgympwad77hs019cz2m8ssaxqfrv";
  };

  electron_6 = mkElectron "6.1.12" {
    x86_64-linux = "dc628216588a896e72991d46071d06ef11aed2cdeca18d11d472c29cfbf12349";
    x86_64-darwin = "6c7244319fdfb90899a48ffd0f426e36dba7c3fc5e29b28a4d29fdca7fb924d3";
    i686-linux = "4e61dc4aed1c1b933b233e02833948f3b17f81f3444f02e9108a78c0540159ab";
    armv7l-linux = "06071b4dc59a6773ff604550ed9e7a7ae8722b5343cbb5d4b94942fe537211dc";
    aarch64-linux = "4ae23b75be821044f7e5878fe8e56ab3109cbd403ecd88221effa6abf850260b";
    headers = "0im694h8wqp31yzncwfnhz5g1ijrmqnypcakl0h7xcn7v25yp7s3";
  };

  electron_7 = mkElectron "7.3.3" {
    x86_64-linux = "a947228a859149bec5bd937f9f3c03eb0aa4d78cfe4dfa9aead60d3646a357f9";
    x86_64-darwin = "e081436abef52212065f560ea6add1c0cd13d287a1b3cc76b28d2762f7651a4e";
    i686-linux = "5fb756900af43a9daa6c63ccd0ac4752f5a479b8c6ae576323fd925dbe5ecbf5";
    armv7l-linux = "830678f6db27fa4852cf456d8b2828a3e4e3c63fe2bced6b358eae88d1063793";
    aarch64-linux = "03d06120464c353068e2ac6c40f89eedffd6b5b3c4c96efdb406c96a6136a066";
    headers = "0ink72nac345s54ws6vlij2mjixglyn5ygx14iizpskn4ka1vr4b";
  };

  electron_8 = mkElectron "8.5.5" {
    x86_64-linux = "8058442ab4a18d73ca644d4a6f001e374c3736bc7e37db0275c29011681f1f22";
    x86_64-darwin = "02bb9f672c063b23782bee6e336864609eed72cffeeea875a3b43c868c6bd8b3";
    i686-linux = "c8ee6c3d86576fe7546fb31b9318cb55a9cd23c220357a567d1cb4bf1b8d7f74";
    armv7l-linux = "0130d1fcd741552d2823bc8166eae9f8fc9f17cd7c0b2a7a5889d753006c0874";
    aarch64-linux = "ca16d8f82b3cb47716dc9db273681e9b7cd79df39894a923929c99dd713c45f5";
    headers = "18frb1z5qkyff5z1w44mf4iz9aw9j4lq0h9yxgfnp33zf7sl9qb5";
  };

  electron_9 = mkElectron "9.4.4" {
    x86_64-linux = "781d6ca834d415c71078e1c2c198faba926d6fce19e31448bbf4450869135450";
    x86_64-darwin = "f41c0bf874ddbba00c3d6989d07f74155a236e2d5a3eaf3d1d19ef8d3eb2256c";
    i686-linux = "40e37f8f908a81c9fac1073fe22309cd6df2d68e685f83274c6d2f0959004187";
    armv7l-linux = "2dfe3e21d30526688cc3d3215d06dfddca597a2cb62ff0c9d0d5f33d3e464a33";
    aarch64-linux = "f1145e9a1feb5f2955e5f5565962423ac3c52ffe45ccc3b96c6ca485fa35bf27";
    headers = "0yx8mkrm15ha977hzh7g2sc5fab9sdvlk1bk3yxignhxrqqbw885";
  };

  electron_10 = mkElectron "10.4.5" {
    x86_64-linux = "d7f6203d09b4419262e985001d4c4f6c1fdfa3150eddb0708df9e124bebd0503";
    x86_64-darwin = "e3ae7228010055b1d198d8dbaf0f34882d369d8caf76206a59f198301a3f3913";
    i686-linux = "dd6abc0dc00d8f9d0e31c8f2bb70f7bbbaec58af4c446f8b493bbae9a9428e2f";
    armv7l-linux = "86bc5f9d3dc94d19e847bf10ab22d98926b616d9febcbdceafd30e35b8f2b2db";
    aarch64-linux = "655b36d68332131250f7496de0bb03a1e93f74bb5fc4b4286148855874673dcd";
    headers = "1kfgww8wha86yw75k5yfq4mxvjlxgf1jmmzxy0p3hyr000kw26pk";
  };

  electron_11 = mkElectron "11.4.6" {
    x86_64-linux = "03932a0b3328a00e7ed49947c70143b7b3455a3c1976defab2f74127cdae43e9";
    x86_64-darwin = "47de03b17ab20213c95d5817af3d7db2b942908989649202efdcd1d566dd24c3";
    i686-linux = "b76e69ad4b654384b4f1647f0cb362e78c1d99be7b814d7d32abc22294639ace";
    armv7l-linux = "cc4be8e0c348bc8db5002cf6c63c1d02fcb594f1f8bfc358168738c930098857";
    aarch64-linux = "75665dd5b2b9938bb4572344d459db65f46c5f7c637a32946c5a822cc23a77dc";
    aarch64-darwin = "0c782b1d4eb848bae780f4e3a236caa1671486264c1f8e72fde98f1256d8f9e5";
    headers = "0ip1wxgflifs86vk4xpz1555xa7yjy64ygqgd5a2g723148m52rk";
  };

  electron_12 = mkElectron "12.0.7" {
    x86_64-linux = "335b77b35361fac4e2df1b7e8de5cf055e0a1a2065759cb2dd4508e8a77949fa";
    x86_64-darwin = "c3238c9962c5ad0f9de23c9314f07e03410d096d7e9f9d91016dab2856606a9e";
    i686-linux = "16023d86b88c7fccafd491c020d064caa2138d6a3493664739714555f72e5b06";
    armv7l-linux = "53cc1250ff62f2353d8dd37552cbd7bdcaaa756106faee8b809303bed00e040a";
    aarch64-linux = "3eddc0c507a43cce4e714bfe509d99218b5ab99f4660dd173aac2a895576dc71";
    aarch64-darwin = "2bc8f37af68e220f93fb9abc62d1c56d8b64baaf0ef9ef974f24ddcbe4f8b488";
    headers = "1ji9aj7qr4b27m5kprsgsrl21rjphz5bbnmn6q0n2x84l429nyfb";
  };
}
