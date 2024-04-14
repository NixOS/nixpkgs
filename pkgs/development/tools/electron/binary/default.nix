{ callPackage }:

let
  mkElectron = callPackage ./generic.nix { };
in
rec {
  electron-bin = electron_29-bin;

  electron_24-bin = mkElectron "24.8.6" {
    armv7l-linux = "8f46901667a904a62df7043991f20dc1c2a00370a42159976855458562cda8fc";
    aarch64-linux = "599e78a3a8127828ea3fa444927e7e51035dba9811ce0d81d59ad9b0bd02b4f6";
    x86_64-linux = "61e87bbd361da101c6a8363cc9c1f8b8b51db61b076cf495d3f4424303265a96";
    x86_64-darwin = "067ce05d628b44e1393369c506268915081ac9d96c0973d367262c71dcd91078";
    aarch64-darwin = "d9093e6928b2247336b3f0811e4f66c4ae50a719ec9399c393ac9556c8e56cee";
    headers = "009p1ffh2cyn98fcmprrjzq79jysp7h565v4f54wvjxjsq2nkr97";
  };

  electron_27-bin = mkElectron "27.3.9" {
    armv7l-linux = "662bbf0e7070c755bfa548560f7117c7f83e1dc716395fd498a5e57fb7238482";
    aarch64-linux = "ab084338fe645c24fef0c4abf5c637d7c9cf621e75ebb75141761213811ee92d";
    x86_64-linux = "c0fcefdf8e38d6bbbe94a488a388f4dc4e72a52126a892e721c2ddefe2d63e59";
    x86_64-darwin = "49597974b9cb8634e5c892701ab27f8d735eda6ee197a478cf84e5fa4ed1d2e9";
    aarch64-darwin = "ac9f14ab54d7d39fe6e7c35a26ad09b5e0a0fb0c6a87ee4b25816515c51db807";
    headers = "0mkssv830h7jbjb984jdp40zxs8zirb8m3ja35gw6rfblc8p0icb";
  };

  electron_28-bin = mkElectron "28.2.10" {
    armv7l-linux = "b6026a7aed2d43447ac9e8fa44f655c1ef0181f11d52bece839cbdbdaa237180";
    aarch64-linux = "509ab6601e083c67e0dd6926b67ae1ca04dd2a2cafec2a41a0847bac86975b41";
    x86_64-linux = "4bf72ce27cb3098024395462c40ebe88c8a105d1db36861c443a0495703fa4ab";
    x86_64-darwin = "4c323bfdc22bf21ced3b42ec05ea685bba647ff8cc00160da70a63d31a18c0eb";
    aarch64-darwin = "ba693449ccafce08d832e9d5661839bdf2f40dfc0b5d7457a04517783f44cbf9";
    headers = "0dgvzly8k149ivcbc5c58alvnzz51lvvi6kc889lcqdkck8wdvbc";
  };

  electron_29-bin = mkElectron "29.2.0" {
    armv7l-linux = "270e822c580d3caddb8efd42b6c99dbaf5a00e88e61992eef1902a975ceb7efb";
    aarch64-linux = "a1367ef7dda8b262e4cebeeb7e3ea155d53e707e56de93a0cd125c501623db6c";
    x86_64-linux = "4f23a3c3a6db796f29057c72f5aca45e94af6dce950da85e72e3d23dc374dc2a";
    x86_64-darwin = "17b37f38369458e5b558d38b66658e6295ab5975ab87b46720c6bed94ce9e07b";
    aarch64-darwin = "3ff37e2eb71abc187ed0f55570f141326a126a4faed1bd04efbb2ff3f4cf2582";
    headers = "0g5zc0ric20wgvska4yva12358csxi647dbx484ilmabciq6b9vd";
  };
}
