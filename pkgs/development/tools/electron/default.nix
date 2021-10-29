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

  electron = electron_15;

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

  electron_10 = mkElectron "10.4.7" {
    x86_64-linux = "e3ea75fcedce588c6b59cfa3a6e46ba67b789e14dc2e5b9dfe1ddf3f82b0f995";
    x86_64-darwin = "8f01e020563b7fce68dc2e3d4bbf419320d13b088e89eb64f9645e9d73ad88fb";
    i686-linux = "dd7fde9b3993538333ec701101554050b27d0b680196d0883ab563e8e696fc79";
    armv7l-linux = "56f11ed14f8a620650d31c21ebd095ce59ef4286c98276802b18f9cc85560ddd";
    aarch64-linux = "0550584518c8e98fe1113706c10fd7456ec519f7aa6867fbff17c8913327d758";
    headers = "01x6a0r2jawjpl09ixgzap3g0z6znj34hsnnhzanavkbds0ri4k6";
  };

  electron_11 = mkElectron "11.5.0" {
    x86_64-linux = "613ef8ac00c5abda425dfa48778a68f58a2e9c7c1f82539bb1a41afabbd6193f";
    x86_64-darwin = "32937dca29fc397f0b15dbab720ed3edb88eee24f00f911984b307bf12dc8fd5";
    i686-linux = "cd154c56d02d7b1f16e2bcd5650bddf0de9141fdbb8248adc64f6d607e5fb725";
    armv7l-linux = "3f5a41037aaad658051d8bc8b04e8dece72b729dd1a1ed8311b365daa8deea76";
    aarch64-linux = "f698a7743962f553fe36673f1c85bccbd918efba8f6dca3a3df39d41c8e2de3e";
    aarch64-darwin = "749fb6bd676e174de66845b8ac959985f30a773dcb2c05553890bd99b94c9d60";
    headers = "1zkdgpjrh1dc9j8qyrrrh49v24960yhvwi2c530qbpf2azgqj71b";
  };

  electron_12 = mkElectron "12.2.2" {
    armv7l-linux = "aeee4acf40afa0397c10a4c76bc61ed2967433bab5c6f11de181fa33d0b168ff";
    aarch64-linux = "593a3fef97a7fed8e93b64d659af9c736dff445eedcbfd037f7d226a88d58862";
    x86_64-linux = "a8e88c67f375e41f3a6f8b8a8c3a1e41b8c0a46f1b731e05de21208caa005fb2";
    i686-linux = "5f0bdc9581237f2f87b5d34e232d711617bd8bf5ff5d7ebd66480779c13fba0a";
    x86_64-darwin = "8a33d2bed668e30a6d64856e01d2aa3b1f1d9efe4eb0e808e916694d32d5e8f2";
    aarch64-darwin = "256daa25a8375c565b32c3c2f0e12fbac8d5039a13a9edbb3673a863149b750a";
    headers = "1fvqkw08pync38ixi5cq4f8a108k2ajxpm1w2f8sn2hjph9kpbsd";
  };

  electron_13 = mkElectron "13.6.1" {
    armv7l-linux = "c8bba8da0baf5cde3eb4823c801c228abfa7943c69131b3701c74e2b342e1813";
    aarch64-linux = "09a1ff29c33a23f19cc702e0147dee03cfe2acedcff6bfb63c7911184b871a1a";
    x86_64-linux = "bfc09dd2d591ad614c8d598dad6e13b76c3baf4f48773e7819c493b524a0bb1a";
    i686-linux = "1ea7c7d19759fa0ee0ddef68c09bcc1c57265436d3f5dab37dad3567f117f317";
    x86_64-darwin = "ce45f17f875d72e791999eaf30a1af39b6e9143e57a653e7f06cfa0bee9b985d";
    aarch64-darwin = "e2f82720acae3a03d7d4b3e7dcc7697b84d5bb69a63d087a7420ace2412e7a28";
    headers = "1bd87c74863w0sjs8gfxl62kjjscc56dmmw85vhwz01s4niksr02";
  };

  electron_14 = mkElectron "14.2.0" {
    armv7l-linux = "a1357716ebda8d7856f233c86a8cbaeccad1c83f1d725d260b0a6510c47042a2";
    aarch64-linux = "b1f4885c3ad816d89446f64a87b78d5139a27fecbf6317808479bede6fd94ae1";
    x86_64-linux = "b2faec4744edb20e889c3c85af685c2a6aef90bfff58f55b90038a991cd7691f";
    i686-linux = "9207af6e3a24dfcc76fded20f26512bcb20f6b652295a4ad3458dc10fd2d7d6e";
    x86_64-darwin = "d647d658c8c2ec4a69c071e791cf7e823320860f987121bd7390978aecacb073";
    aarch64-darwin = "f5a7e52b639b94cf9b2ec53969c8014c6d299437c65d98c33d8e5ca812fbfd48";
    headers = "1y289vr8bws3z6gmhaj3avz95rdhc8gd3rc7bi40jv9j1pnlsd3m";
  };

  electron_15 = mkElectron "15.3.0" {
    armv7l-linux = "dfe2851ef94c17eb905cd8cf00b585be072e20a79a02c0c42585a0f51b8cdb20";
    aarch64-linux = "e0bb8d663dfbe8b65b9e38d4af992a919adc639acfb8748d95ca5b9bbcd7a83c";
    x86_64-linux = "7cb9c6c9c61848f7d82aaac47ca97bb78c6061e73b176fd3a323652c07335087";
    i686-linux = "289ef7d53c440a576839a4ee092284009235d740404ea07e6bf82f33254ae8df";
    x86_64-darwin = "667da0d56bab968d28c41c1f53b901fb685e56d1f56faf33912a240a0397bab5";
    aarch64-darwin = "9cf5caafc7cbf0e91483e24d5a696b81618d293a5eccd4d122c57baaab88724c";
    headers = "0jicbplni608cjxwhlrzxkxc9w9b4h6zqssilc9b0yr73jq1fyrd";
  };
}
