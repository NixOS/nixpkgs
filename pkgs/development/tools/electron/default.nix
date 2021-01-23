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
, libappindicator-gtk3
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

  electron_9 = mkElectron "9.4.1" {
    x86_64-linux = "36c6c33e2702f591c34a7e6ebd7d0828d554a4ce2eafb319a0cd16ffd4cc4b28";
    x86_64-darwin = "3e2f87d899be684eab226c572c566e89c05114059c9add1a33d2be63100b18fd";
    i686-linux = "be5f8d18f11ad7c0655faec4040a8af6239f29f1155210024a01826a30b0dbbe";
    armv7l-linux = "b710a0e3b80ef265760d49c9210f78a6410007521b0ed73c8b868b05d22a0a60";
    aarch64-linux = "e2fc73309780fc0e9b5abebcb8256b2bc389672f0bcc261269da5891a3df66dc";
    headers = "0sabqcjd6gcc6khyhiz3rk30p1y4bxsajy4rs9866bqyafq86j6q";
  };

  electron_10 = mkElectron "10.3.0" {
    x86_64-linux = "1a4afb659400c7acca0734df1b981b867e5dfdd15d4d3b73fd276d87b682f089";
    x86_64-darwin = "9c5cca484b28dc5cca89a7f1c77e65b3a04251f4eee740265c358efae351cb94";
    i686-linux = "fcb298bca0ab229e92b92c418d3e352885ff4291f735a35c7822b3ca17ae8a86";
    armv7l-linux = "48accf0fbef1f2d1a81e12c2e66b9280f871029b16947d0bebe036cf1fb71b1c";
    aarch64-linux = "2c99b4ec87ba657c33efb3a7e907e3f3e315e87347954231cb8bae393c1c96fd";
    headers = "1k97pfzxqrgw4y76js2chq13avgp9czin9q9mlh1zdf13bih96hj";
  };

  electron_11 = mkElectron "11.2.0" {
    x86_64-linux = "a2ed11a5ec9ad10302053e5e2bdf2abf0f9bac521e4f80a377308bffe8c24c00";
    x86_64-darwin = "c8485cc6cb754bccfb1a01db93f5f0f1ee1ed3017551f3d25a1191c7c7aea654";
    i686-linux = "508b9276f97c66418e530cbfa584701d4b0a42825fb2519b21ff161db1dc121f";
    armv7l-linux = "edf1ad6606eab5efc1c9a33ce16489dae1df21ce6e69166f4c8da27ca6fde2ca";
    aarch64-linux = "ed8e318ce0ba92058efdc667790bcbfce1c7f888f9d94038c1c76ed8678158fc";
    headers = "0mwv9vm2km6sawyds87fzy7m4pcmmwl9c2qihs1nc7cwmdz388lv";
  };
}
