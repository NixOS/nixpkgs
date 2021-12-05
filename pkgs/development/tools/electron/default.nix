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

  electron_14 = mkElectron "14.2.2" {
    armv7l-linux = "185613c0141fb57b716a0fe421aab91100586fb312a92c66785b956f54451b92";
    aarch64-linux = "8e54ef999d85454d0fa1679bece3143a72086e540eb910f4f2a8a84ea07ef003";
    x86_64-linux = "e419d1fb786f828aa3f679647e7ece889a6dcc830612909c45f4adc2f976348a";
    i686-linux = "76e77d9e45c8d94605313bba1fea87c0b76f2f95c317ef2470cc4f4d88f1b195";
    x86_64-darwin = "117377067dc5afca00db6380461c98870632cbcb97dc5dcc8aa015a9f42b969d";
    aarch64-darwin = "ac03eb8fa1781e675b5a55d83438184d86e5faa6b93d008796fa8f151a31fd14";
    headers = "0l2mwi1cn1v7pnl3l56mq0qi8cif39r5s2lkgzi2nsr71qr9f369";
  };

  electron_15 = mkElectron "15.3.2" {
    armv7l-linux = "40d2f83a3cd29350edfff442ec1d9a5a681358ad9a7a086adf0ed8d0afa4145e";
    aarch64-linux = "c4c37b852a5576420d43c0a7d3b62be343fc0340134e9f0a7791c3c9285fe249";
    x86_64-linux = "10b85813d5280f97125437c65a002aa783f204247d501fb58786ac2a7144bb7d";
    i686-linux = "4a138dbf3d7e34915de73e0224c434666b0c9c5f335ed22e72014b20147378e6";
    x86_64-darwin = "0bd7e44d41bcdd048a2ac5dc4e1eb6807e80165ce5c06f1a220b20f10579be75";
    aarch64-darwin = "9eae07658b7d9a5eb318233a66c3933dba31661cf78b7b156d3d20ab7134f4c3";
    headers = "0r1qxgkpcn03fd28zbz86ilhsqg0gzp9clbghr5w6gy5ak8y68hz";
  };

  electron_16 = mkElectron "16.0.2" {
    armv7l-linux = "bba43eb1e2718f04f6d91096cf22d4c49cbab0915f48b3b22b8f94f205eda2f0";
    aarch64-linux = "3a2ad9c508bfb8e1b2635a3af0a7495e1121bc7aea64a9b771322a60bb82e265";
    x86_64-linux = "2f96a5b773b790d968a6b2c1142f8d231587b775be113e7ee90d9a89bec8cd70";
    i686-linux = "4fd01951b3f57b69731f85d6eae6962257c3a70c37d74751a098bc00ea43085a";
    x86_64-darwin = "a3b9fd83dea4cfa959ddd72be4cbcb8d0503f4ab2741705561b62de8b5218895";
    aarch64-darwin = "3894d141b060d37f1248556525e96a9fc1d4afc237b740f5093bdcd5731972d1";
    headers = "0h1gzrd6rdd217q0im0g1hr3b037dmi4v6wk30kzb12597ww59n1";
  };
}
