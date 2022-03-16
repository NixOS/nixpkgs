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

  electron_13 = mkElectron "13.6.9" {
    armv7l-linux = "e70cf80ac17850f3291c19a89235c59a7a6e0c791e7965805872ce584479c419";
    aarch64-linux = "cb570f77e46403a75b99740c41b297154f057dc3b9aa75fd235dccc5619972cf";
    x86_64-linux = "5e29701394041ba2acd8a9bb042d77967c399b8fe007d7ffbd1d3e6bfdb9eb8a";
    i686-linux = "7c31b60ee0e1d9966b8cf977528ace91e10ce25bb289a46eabbcf6087bee50e6";
    x86_64-darwin = "3393f0e87f30be325b76fb2275fe2d5614d995457de77fe00fa6eef2d60f331e";
    aarch64-darwin = "8471777eafc6fb641148a9c6acff2ea41c02a989d4d0a3a460322672d85169df";
    headers = "0vvizddmhprprbdf6bklasz6amwc254bpc9j0zlx23d1pgyxpnhc";
  };

  electron_14 = mkElectron "14.2.7" {
    armv7l-linux = "bb0c25671daa0dc235e212831d62f18b9a7f2692279bcd8e4a15f2d84ee7124d";
    aarch64-linux = "149c5df2cf98ee0a2ce5445b3fb00752f42c3f7ab9677b7a54ba01fba2e2f4ec";
    x86_64-linux = "ad80f424e8d8d79f0be078d8a1ddef8fd659fa3dd8aaf6704ab97f2a13489558";
    i686-linux = "82b29272cb52dbe969c0bd6cf9b69896c86abe1d9ef473a3844c0ab3dc92b353";
    x86_64-darwin = "2a5d8336dcd140158964801d482344756377d924a06e6605959034a41f7e026b";
    aarch64-darwin = "b45869ff61bdf392bca498529b6445d47a784079f6a33af6b19d517953f03fd8";
    headers = "0339fs3iyp869xi1xmn9z2b1n32wf408cc0z9bz6shns44ymkyhd";
  };

  electron_15 = mkElectron "15.4.1" {
    armv7l-linux = "e0fe5daed46a5d718b3209fa301aea743df694daf6605f9313f4ca6c70fe5167";
    aarch64-linux = "fa108edd4c146811bdee842fcd278b046ae0ff157de5e072c3ff3ac0bcb310c2";
    x86_64-linux = "867095924d434b3918df8576e7af94fecea4d29461fcfb69c40161f02158ff15";
    i686-linux = "8e79fa9f4125f254abb437445fed8f3f8ec10dd2462e1ced3e7df49c622e087d";
    x86_64-darwin = "899d16a0e0157809c297ceb3710c53441ec4396333d9ad5b65297446874e14dc";
    aarch64-darwin = "8295bf45dab1131dfdfd15654a0b1d85bfae221052ba64353368a2c0faaaa3ff";
    headers = "073697wjq60cnz42xmnjsr0xqcmcsl4m48mmzrz1rxrc8mvi86gr";
  };

  electron_16 = mkElectron "16.0.10" {
    armv7l-linux = "1a72fe59011cfcc1f376f2948dd5a70d2f75d6c12fb682a0246d2e596227b5e0";
    aarch64-linux = "46cd1393816364a666ead410505bce4b51d68ce872446a71d16886b88c4b275a";
    x86_64-linux = "3b4779e41e27200ce5fa94d20f9df05ff5c757be6805eb0e8952fe198d66f324";
    i686-linux = "9e1426a8135d3fe195ba9fc1a5ea5ad4d5ce96bd513691897b39106698e3c3c8";
    x86_64-darwin = "00b0222efa67fbb29f723fabebc4221646ebd6d5fdc09524df9a203f63ce660c";
    aarch64-darwin = "1203f6ec4e8b97312254ceb122ca4399f39ae67bfe1636e426a798c89ec2a9ee";
    headers = "10f6px88vg6napyhniczi6l660qs4l5mm0b9gdlds4i1y94s1zrl";
  };
}
