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

  electron_14 = mkElectron "14.2.5" {
    armv7l-linux = "d6f7e2fe6088f57ecd455035e0815c20dd1d84b4cbf669e5fa355b96f36eaf2e";
    aarch64-linux = "c8a1a7c5c04462bbe6e148587a72b002ab4bb90aecb9686546b22580c0f9fa52";
    x86_64-linux = "5820ea6c9cfe02096a75df43cab7cdfe5947d6d90207e98c563bd50c400f8110";
    i686-linux = "8099fc3b137e80c5e65493dea2cf3dfb923e86693f3b082429f6fd949560f540";
    x86_64-darwin = "258eb29426a5f275c49284be6818f856ffc29d04fa9cef6fafcdcd207092281d";
    aarch64-darwin = "38a19828c1d7ff5fb49c5db5a706482f4afbae9fecaedaf9ebea0a5765bf952d";
    headers = "172h9ba1s531y3s751inwsia6kr39412yivqkpdc58jmn47nmgb8";
  };

  electron_15 = mkElectron "15.3.6" {
    armv7l-linux = "4c105be3dc38ea8899f9fe58c05dfbf20e0d43e9b35ca815c43329d17b714d36";
    aarch64-linux = "3d06de32f02e38039c3c9deb418e3b9dbcda30f387f27e54fb1f1be068b80989";
    x86_64-linux = "5a9a3e37e92ad67d2a4ebb5ac85cb817d682fe2ca0b37b924d7f40085d246cc9";
    i686-linux = "32ff47793c8123fa6220ff9e7c524e3b89c0411e94bdb4d9391038cc58449b5f";
    x86_64-darwin = "faff636a6deedc3b7a3c900aef187baaeec2b83ccc405c56e3ea18d68894b82c";
    aarch64-darwin = "ae7350a7daa6eb2d21fa001c38217bc46a3894f843962c5cca192b837cc9d81c";
    headers = "1mbffk26kdn1id809sdg1kdhrf285zm9ls40b5zaflcljvqg3i2x";
  };

  electron_16 = mkElectron "16.0.8" {
    armv7l-linux = "be3a598d5f7c677c11831b78a8a82d95132ea760bb643e526426b91fdf27aff7";
    aarch64-linux = "465cd93d69ea2e3273339d48bef58e7359b692da5535bff5882e803c22535ec5";
    x86_64-linux = "25767a94d4b0927616ed5008889cd65bb073c7005209671b34045f91d698c857";
    i686-linux = "1cedf35f501ea1512fe9ae5cae47a72e093b6eb7297f76b726551e4a33a593a5";
    x86_64-darwin = "a3c5e5368165304fc9392e3a5b59480965cf0f91f7d889257e6a622f48051cbf";
    aarch64-darwin = "dc8414d7b9a967bda530c83a81720519931aebf541cfaed142ee2042c16e683a";
    headers = "042gz036dzwbvvxvgbgkdb5nq7p8a7vcan6c35l7imgv1hd4g5v4";
  };

  electron_17 = mkElectron "17.0.0" {
    armv7l-linux = "29b31c5e77d4d6d9e1a4340fdf08c28ae6698ea9e20d636cec8a59dc758815ef";
    aarch64-linux = "e7bf2ec09b8a7018ba417fc670a15594fb8f3e930626485f2423e9a89e2dcbd0";
    x86_64-linux = "dc74e28719a79f05dd741cda8c22c2bb164dec178c6d560af085910b37cf000b";
    i686-linux = "6f6fe5fa0452e871abe82dbd25d7cf92ab7011995b3b2b15d04d8691ddc9e9de";
    x86_64-darwin = "c35d81af3a3f156059a53436d7874a46770cbf6e4e5087f7caee269e66abb636";
    aarch64-darwin = "7dc5eabc7e582a031d5bd079eeadc9582f5605446085b4cbd1dc7e7c9e978c45";
    headers = "1i3sx1xy62i4f68zbsz1a7jgqw7shx0653w9fyvcdly2nraxldil";
  };
}
