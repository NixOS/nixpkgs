{ stdenv, libXScrnSaver, makeWrapper, fetchurl, wrapGAppsHook, glib, gtk3, unzip, atomEnv, libuuid, at-spi2-atk, at-spi2-core, libdrm, mesa }@args:

let
  mkElectron = import ./generic.nix args;
in
{
  electron_4 = mkElectron "4.2.12" {
    x86_64-linux = "72c5319c92baa7101bea3254a036c0cd3bcf257f4a03a0bb153668b7292ee2dd";
    x86_64-darwin = "89b0e16bb9b7072ed7ed1906fccd08540acdd9f42dd8a29c97fa17d811b8c5e5";
    i686-linux = "bf96b1736141737bb064e48bdb543302fd259de634b1790b7cf930525f47859f";
    armv7l-linux = "2d970b3020627e5381fd4916dd8fa50ca9556202c118ab4cba09c293960689e9";
    aarch64-linux = "938b7cc5f917247a120920df30374f86414b0c06f9f3dc7ab02be1cadc944e55";
  };

  electron_5 = mkElectron "5.0.13" {
    x86_64-linux = "8ded43241c4b7a6f04f2ff21c75ae10e4e6db1794e8b1b4f7656c0ed21667f8f";
    x86_64-darwin = "589834815fb9667b3c1c1aa6ccbd87d50e5660ecb430f6b475168b772b9857cd";
    i686-linux = "ccf4a5ed226928a30bd3ea830913d99853abb089bd4a6299ffa9fa0daa8d026a";
    armv7l-linux = "96ad83802bc61d87bb952027d49e5dd297f58e4493e66e393b26e51e09065add";
    aarch64-linux = "01f0fd313b060fb28a1022d68fb224d415fa22986e2a8f4aded6424b65e35add";
  };

  electron_6 = mkElectron "6.1.12" {
    x86_64-linux = "dc628216588a896e72991d46071d06ef11aed2cdeca18d11d472c29cfbf12349";
    x86_64-darwin = "6c7244319fdfb90899a48ffd0f426e36dba7c3fc5e29b28a4d29fdca7fb924d3";
    i686-linux = "4e61dc4aed1c1b933b233e02833948f3b17f81f3444f02e9108a78c0540159ab";
    armv7l-linux = "06071b4dc59a6773ff604550ed9e7a7ae8722b5343cbb5d4b94942fe537211dc";
    aarch64-linux = "4ae23b75be821044f7e5878fe8e56ab3109cbd403ecd88221effa6abf850260b";
  };

  electron_7 = mkElectron "7.3.1" {
    x86_64-linux = "66f37aadf65c0274cc6e46b09e52c38b2c8c5b2d6bbf1cd8196cd69b9f9ab737";
    x86_64-darwin = "351b30cab32539752ce5f9b53d2345352df922d57a152643c4eeb636a8941d23";
    i686-linux = "f80b8a684da13736d7614ca4ad5704812d12537111cb45010e5f42e7e4403554";
    armv7l-linux = "ef054696f4138e261b1310522d57bbdc5336e34488b3e273a8a794f8c26509c7";
    aarch64-linux = "f32376ca85c9017b7ab399e58fa176d882baacb048dd69d816831f8dde9054bb";
  };

  electron_8 = mkElectron "8.3.1" {
    x86_64-linux = "d5ad2bd32f7bf88f869a401017b35be0ea71e6fc7798fe2397b21602573e2639";
    x86_64-darwin = "abe864d9e6327d499120f328e699f4819110d4245bce2f92b84e19d8cdc1c771";
    i686-linux = "e75692c062b15c7f664cf3ff30832a526f3f66080469f7f93befaa4e0860c011";
    armv7l-linux = "cfa0a14225b617492a311c21ad973f24708bc4013a992271368006cdb12ed488";
    aarch64-linux = "1b9cd3ed7eb53ed914ac04c82d736c2677af807e553c87f0698890c2a3dcfd57";
  };

  electron_9 = mkElectron "9.0.0" {
    x86_64-linux = "03c69d66ae8784edcc6a4b8081eb4e07da802035a6257fb6e2260a456371224f";
    x86_64-darwin = "86096d2ecff0698957bfbbe8a8d56c7f9ed9abe7e5a5bfe84a8f4af0635625e1";
    i686-linux = "67ea9e04db5a709b10d2f101d977e803b5f5da9e9573cbcc7bce362b1a9406d7";
    armv7l-linux = "7917624b81318197da52de04073e07c4b2d3947737d4103f647a8abc907600c0";
    aarch64-linux = "e3dd2e15cfd346a59c69ff4b0b234daf5bb06790b508ae0056a55c17eef78a9e";
  };
}
