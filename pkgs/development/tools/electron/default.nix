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
, libglvnd
}@args:

let
  mkElectron = import ./generic.nix args;
in
rec {

  electron = electron_17;

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

  electron_14 = mkElectron "14.2.6" {
    armv7l-linux = "fd115652f491fff6a28bf39dc41e3c7f1b638e7dcc7856c33b6a97c7763ea9a3";
    aarch64-linux = "530df3030aeb2c0f67ba4bc210c0f0fe77670001d2ba30ad6858f74952528df2";
    x86_64-linux = "c3f91ced7e429079d43c182f47cea1eceef17ab65c390e15f9c6af56e58ed3d9";
    i686-linux = "d66881d0747c99618c500b46e044eb4e97442400624fbcf9a6af114743e6e8db";
    x86_64-darwin = "15db43c17a33bf9e31f66f5025e0810dfbd2b237f7645eda51409de7930cc9d1";
    aarch64-darwin = "a5f7b8cc5f6dfc7561368d2f09745967bb553a29a22ef74af8f795225483338a";
    headers = "0rxbij6qvi0xzcmbxf3fm1snvakaxp9c512z9ni36y98sgg4s3l8";
  };

  electron_15 = mkElectron "15.4.0" {
    armv7l-linux = "40c073a3b416f83264327bdf5e33b334ffcd56a729ef237360d66f520f670d16";
    aarch64-linux = "ef18ba74b4fa34a26f9ee819bb908c60d0dd9ec2048414629979760f262d72f8";
    x86_64-linux = "5bdea4cbf5559491e9ad9f365fa6f7ec26603fd6f68bfa8848f2884ebd51662d";
    i686-linux = "636d0e28bb20ca127c9b8722fe39e7e7d95fc63bd15b156b7af563296b3d9595";
    x86_64-darwin = "8a132b2be0f27c7e8fa9a91a8b4b0fcdf3ec571c721cb5f5610dc8a6b3f0fd26";
    aarch64-darwin = "82b29c37a427464a9278d617435ca19f472b00689c9e58163e99f30b90f33046";
    headers = "0fc1sck7g160klpqzfcqv9zc45ia914mrncyma58zzcbzpk6k6yb";
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

  electron_17 = mkElectron "17.1.0" {
    armv7l-linux = "09d92195821aad4ac03fbc858287a7372b6aa059081bb825d267853ee1b0425d";
    aarch64-linux = "6a34d6802d44a391902f53baf0adc8b819d33e7c31b34614757b17b3223c9d1e";
    x86_64-linux = "106ec28a5969366c1e1f642cc33ac41950c68bd182db23b04d7ac6886bfe28e8";
    i686-linux = "19fe206be07a6df7f9f0ecdb411e3cafd3a53618edb19cc6adc77156f698444e";
    x86_64-darwin = "bd80d6b0b62c9bec195d264aa21a255f4324a8b56849e04972c1fcc262757c31";
    aarch64-darwin = "83fe2fc24976d09a0e0fcc3a60226f190cf9b67287fe4434d3d76d59fa45315c";
    headers = "1zv1pigfbis1bsan28wx3bgkdwjc48pjq19wmxs73kd1khsy6w8r";
  };
}
