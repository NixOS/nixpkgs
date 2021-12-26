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

  electron = electron_16;

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

  electron_12 = mkElectron "12.2.3" {
    armv7l-linux = "4de83c34987ac7b3b2d0c8c84f27f9a34d9ea2764ae1e54fb609a95064e7e71a";
    aarch64-linux = "d29d234c09ba810d89ed1fba9e405b6975916ea208d001348379f89b50d1835c";
    x86_64-linux = "deae6d0941762147716b8298476080d961df2a32d0f6f57b244cbe3a2553cd24";
    i686-linux = "11b4f159cd3b89d916cc05b5231c2cde53f0c6fb5be8e881824fde00daa5e8c2";
    x86_64-darwin = "5af34f1198ce9fd17e9fa581f57a8ad2c9333187fb617fe943f30b8cde9e6231";
    aarch64-darwin = "0db2c021a047a4cd5b28eea16490e16bc82592e3f8a4b96fbdc72a292ce13f50";
    headers = "1idam1xirxqxqg4g7n33kdx2skk0r351m00g59a8yx9z82g06ah9";
  };

  electron_13 = mkElectron "13.6.3" {
    armv7l-linux = "a293a9684e16a427a9f68d101814575a4b1dd232dc3fca47552f906019a6cadc";
    aarch64-linux = "1599d259832c806b98751a68fb93112711963d259024f0e36f12f064995b3251";
    x86_64-linux = "7607422a4ba80cda4bd7fefb2fbe2f4e0b9a73db92e1e82dc01012a85b5d0d2b";
    i686-linux = "db9261c05ed57af2fcd4a84b89d299c76948b9d57ce0dba38e3240eb43935257";
    x86_64-darwin = "6bf09794d6f020bbaaf806a7758da125137b3c96646f4503eb81b9541e50e02f";
    aarch64-darwin = "374ddf0581794b31eee900828172f9218193c032c0e46bffcfac6aec95c22f1a";
    headers = "0v1n8izy83qq3ljs6191a7mzr6nnda5ib9ava1cjddkshl8pampq";
  };

  electron_14 = mkElectron "14.2.3" {
    armv7l-linux = "d4ed85690c49b6ec1b532256bd63ccfb670d14da9bb5ccf706e03da2f5fe377e";
    aarch64-linux = "ac8be1a06ad4b3da16438cc9c257b3c443417d5d9272830b0d51c1f2c9b14f52";
    x86_64-linux = "c72ce5943e9e5e9b10b0822b3e60de74612db81c4ebaf475e5fa8735af344b22";
    i686-linux = "9dec585682c0a08f048f1eda6a931cad3c85d47842786aae565af930a7ef7b51";
    x86_64-darwin = "fb90d61855b63ac1115a60683d476931a6b6bf194e77867192d927bbb9051070";
    aarch64-darwin = "035e6e2e8d50e867eee37b0631fc95b3f0e8760294af71c23bc73c0f3fc99f83";
    headers = "0m03nb1nlwd03wn765rs06yiqzkxlk9jafab0zaxywsq94z5np0y";
  };

  electron_15 = mkElectron "15.3.4" {
    armv7l-linux = "caff953cbffdac63307b75a3b78be82ea6003782e981edfdcba14da5ee48b8b6";
    aarch64-linux = "dba1e09b3e4924148b57539d86840fa22e5500f3e15a694dcd2e26b830c1f780";
    x86_64-linux = "5e13b64c3b1b025ddea92b3bda577e00fc533902a9cf92bfd87b976637f7b59a";
    i686-linux = "1253e837e98fc41c14f6b71f0f917b8f42a0777bd2554046567b512f747240d8";
    x86_64-darwin = "ea1cb757f9c8c4c99c840357ecab42a0bcbe8c7a6a3a1265106c238088ad18f1";
    aarch64-darwin = "65b9b3235efdb681e3a4db85068dc9fe6dfbcb7fbb146053c0a534e4b44a2f7a";
    headers = "1xnbzskvf8p5a07bha41qqnw1hb68f019qrda3z2jn96m3qnj46r";
  };

  electron_16 = mkElectron "16.0.5" {
    armv7l-linux = "16381d22f6f3c7990435598fc50addf8addde2fa749ab23672733ec90b8d53ef";
    aarch64-linux = "6274bdf2a3894ce9ddb70800df497a034893e1be5e2d07763e339550009d53b6";
    x86_64-linux = "2830a9f8fc5e7fa4f70997e11d55b250e90db511b29da22699e1fe23b153128c";
    i686-linux = "363e2588f57f3d31e506e759f723768b543baf248dfb518d06747ffa0a8d8ab1";
    x86_64-darwin = "0bb7f2c506d8c3e9ef7ec4049baf87a3365cbf80c569f6eb98ddc1a2ddb653e6";
    aarch64-darwin = "de4eac412a942a0b238792a38c0c80691d1a7ef2eba850c15619c0db9da89f1a";
    headers = "1pdi86sq60z9bqd81fvgl14c3bk21wk9mwkqyn653yq4zk0mqpi5";
  };
}
