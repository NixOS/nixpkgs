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

  electron = electron_13;

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

  electron_11 = mkElectron "11.4.9" {
    x86_64-linux = "c18ed2e16e60ca1eddd01ab2e4fff2bbfd9f197ab17b7577155f05687297d7be";
    x86_64-darwin = "ec34759ae768e55449c23244283c8af3dc5d5ab533d64cea0231be0a0878ebdd";
    i686-linux = "ef9125268e03f2f1d13c2b2505ba2529af88a8397cad640bd35116caae7ab296";
    armv7l-linux = "b43c00f4a0b4cf8affa09cedff93066d23d57a6148af383a8fc9f6d25b63d449";
    aarch64-linux = "3df038538056fc4a918afe07138052b1f53648c411add47c3a18abe8a30e6f71";
    aarch64-darwin = "acf880cfaea9ca382831df165fa7ef7e0b442c663d5a586cdfe0baa1aea4e17c";
    headers = "1wfhc22g680pvv85rq8d8lw4vphpr700fmzs3nwxixxnzhp1sb79";
  };

  electron_12 = mkElectron "12.0.12" {
    x86_64-linux = "98e7cc5dd3f161c37cbbd9aef90d55c51531a4bad8221a9d1f92e78014758054";
    x86_64-darwin = "3a39933c1c83406e4ddbce2af193e9a6b7b77f418c4f1d5e7b8f9edc348acd15";
    i686-linux = "2a06936fa13929342ebb7521d2e3e8b4a7a08ac1d757c0521a047b4cf0a979fc";
    armv7l-linux = "c0a2c13d99a1152aa6252fd8237207a6f395b70d0890eba5b7209a03beb9a6ec";
    aarch64-linux = "a92e2eaebab75b93eda0bc523ba9262a32db95c7546c095fee93d39a304521a0";
    aarch64-darwin = "810a1f36574a2db8d7d4022a042a65cceec3443644487868c5609b16b5dfe29f";
    headers = "1qis2k8yc7g1klvhiysjrgl5gclx4idxdz60kh8ldrji5a0lgha1";
  };

  electron_13 = mkElectron "13.1.4" {
    x86_64-linux = "096909396be9fac888ca35093d16bdb50a965e3200823f2384574c359f15cd4f";
    x86_64-darwin = "3d9980f8062766be3cfcfd54b9fd9f469993df06d538a2324c4879eae1284c84";
    i686-linux = "73c8b1fc01a89a5f9b12de38ed70bd01686e50a55d817f0cdf5914e953bdc868";
    armv7l-linux = "db2fe2f499865ea697cacef992fc0042ac0f75da4c016d64e5c41deae7f5eb72";
    aarch64-linux = "4acdd4eae499e1ed42871ed8b744fdef9f608f5613742090cc20e4f6b5314ae8";
    aarch64-darwin = "e961b7d361c378e4adab7903211ac7200684cb91044c3b300acde04ca24d0468";
    headers = "1h1sr5nk37asbj1fadgjzksgr876wxdmq3b017bb9k5kcgajcmqr";
  };
}
