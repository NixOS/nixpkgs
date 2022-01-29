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

  electron_13 = mkElectron "13.6.8" {
    armv7l-linux = "94cf65f1454ea26017d80cd98a9fd3d9c9767d2a2ba7030d29d674d643814d59";
    aarch64-linux = "5579b20438e5637f0ec8e0f07a46d5359691bfd631290372d538217c1904e07b";
    x86_64-linux = "054f2a83a1361ea25438b609a681adb8c8dec8a2f03fd5b3605b10818799ea01";
    i686-linux = "87cb2af357ba568fb56c99aea0a25714501fbacd02ce27c9ba55e3db8deb5535";
    x86_64-darwin = "d8fa0254c4a5fe61f5a047f9cb6968a2dbc817cbd10cac1fd9c9d362608bc58d";
    aarch64-darwin = "8e59ea97744791f7edaf3ff4c2fa1a144f9737c165c29ee0f0d13175a2140399";
    headers = "0s253jdmfyfgb5mwslqd50g623fwj3dgsgsq4cn3pl5qfpmcm26x";
  };

  electron_14 = mkElectron "14.2.4" {
    armv7l-linux = "d644d2df745a9809794929762db1faa56b77f519ccc0d430dd2238235739ace3";
    aarch64-linux = "1f198a61a5f67954f568e49879e390c94ef9cb05545664e24bac513e05dea0d9";
    x86_64-linux = "faf6c0501811e3dec056f536e53f0ec087345b852e7de47ae86ea175cc070a2f";
    i686-linux = "1f9baa2f3aa1cd935cc29f67aa273c8b1b65da144af3894bd855ce02a6730fc1";
    x86_64-darwin = "4a3c146da911162c7081e280f2c311c41f132e1d3274bc3676ed71cc9392dc5d";
    aarch64-darwin = "279cc3c04c7db9f3361b09f442750f4d18c8b2c7f633bca17aa9fb3656bfb74c";
    headers = "1zkf1j82psbj9mw8zb9ghl9y6bkw77cxqzkp3q1bbn6wvj41lvyh";
  };

  electron_15 = mkElectron "15.3.5" {
    armv7l-linux = "c5540cd94711a31fe0098da982d4a25ed1b606e0d4213c9f7863826b2c8e7eaf";
    aarch64-linux = "6550387135605b64b8549b1034eae672a8f94419032dacbaff7b92934cc0508d";
    x86_64-linux = "3b61eaa48f3c5f1983a24152e6b12f39c3a29abb52d17c13891c16a25e3c209a";
    i686-linux = "30d6de074bebe985bb07f20788a8378c7fa1ded564e3c1e8183b0113ba76b282";
    x86_64-darwin = "fe2c138bb11b3db07d02c1cbf7838765036ac2552582f9ce2265ffe6609ea2e1";
    aarch64-darwin = "7c887b8ae24ad7ca9585a001f29108919bc39d27c3818012aeefb8072e23178d";
    headers = "0fkvwlnxjy8dwfnxhgk6i4qayhmg7dbqmd9nfi94a7kdbwp714r5";
  };

  electron_16 = mkElectron "16.0.7" {
    armv7l-linux = "8a8567c745ab1c2b1de19305da0a0036ba100b27e1fc4eb014aca325aff3193e";
    aarch64-linux = "6d27cc9acc3f580118cdd685d629d39c2a1fc094376b719fa0100a7446f8fede";
    x86_64-linux = "544cd6d48262f24c8a82d2e8079b20889ec5e83959404fdda9ad00c86e9efa70";
    i686-linux = "8b79ce5fbc704eb03c34d4b96765314074a687ae3165cab21f84f77fee36d755";
    x86_64-darwin = "e5c825d4cfc1dabd066986fa1cae3ee880f222b053c760b700b24899fb02d4db";
    aarch64-darwin = "9fa9dc44e5d71de7a999b3db07a583e0a04252747486c16955232eba498b259d";
    headers = "0r4gd2v9rzrg1msxw62rq1s93ifrjj4yb4gfcma5mbj88m3v5p63";
  };
}
