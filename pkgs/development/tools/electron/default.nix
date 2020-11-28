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

  electron_9 = mkElectron "9.3.5" {
    x86_64-linux = "9db6610289a4e0ce39c71501384baef5a58dde24d947fdead577f2a6b59123aa";
    x86_64-darwin = "d30aca66a0280a47284a3625d781c62fd0bb9b7f318bb05b8b34751ee14a3a78";
    i686-linux = "b69614b1d34f9a98e182cc43bf8d35626038d300ee9fb886f7501dbb597c7e61";
    armv7l-linux = "d929dabe7a83df232ec08b138ed2b0540b86e7dfa33f2f45f60b9949fa1ca88f";
    aarch64-linux = "41fafb72f0d18d3b9f34e6f4638f551d914aae6eb6f9ea463ace5ee4bf90bb30";
    headers = "10snhi8q0izd3aqdfymhidfja34n4xbmd7h3lzghcczp77is2i5b";
  };

  electron_10 = mkElectron "10.1.6" {
    x86_64-linux = "d538ed7bb632d213a4b88d13bb038de65b85ae7b28a574c9efac7dc5a502ebbf";
    x86_64-darwin = "7f24c666cc59935a49e5b82b4d4c1d008e4d6fac49c78d0645596f2cc8c7218d";
    i686-linux = "009bbee26ddbf748b33588714ccc565257ff697cde2110e6b6547e3f510da85e";
    armv7l-linux = "e8999af21f7e58c4dc27594cd75438e1a5922d3cea62be63c927d29cba120951";
    aarch64-linux = "b906998ddaf96da94a43bbe38108d83250846222de2727c268ad50f24c55f0da";
    headers = "1qj6s0h612hwmh4nzafz406vybr1rhskal2mcm1ll62rnzf98k3z";
  };

  electron_11 = mkElectron "11.0.3" {
    x86_64-linux = "e2b397142ea10f494c9922ee0176fef1ea4a1899a3064feb038c9505e57fb1ff";
    x86_64-darwin = "32d5eeb03447203e1ae797bf273baf6fb7775ef0db9a3cfa875fdcddf7286027";
    i686-linux = "c1a773140d251938e2a2acd2ef52f64fc4185ea0dcab1c34c8fa07e08ec25729";
    armv7l-linux = "932e6499289b97c33ab239a72b4cf1d0a7152d1ff9ade01058d3219481da0c2e";
    aarch64-linux = "db92e96c03dfbc56159dad5d87ff11f2a1ff208730e9821788bd45ddb5db63c0";
    headers = "1r2s7088g72nanjc0fqrz1gqrbf1akrq6b7a9w6x7wj95ysc85q0";
  };
}
