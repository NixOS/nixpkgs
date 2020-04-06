{ stdenv, libXScrnSaver, makeWrapper, fetchurl, wrapGAppsHook, gtk3, unzip, atomEnv, libuuid, at-spi2-atk, at-spi2-core }@args:

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

  electron_6 = mkElectron "6.1.7" {
    x86_64-linux = "7fe94fc1edebe2f5645056a4300fc642c04155e55da8dd4ee058a0c0ef835ae8";
    x86_64-darwin = "1c790a4cbda05f1c136d18fa6a09bdb09a1941f521207466756a3e95e343c485";
    i686-linux = "1afd8ea79acb2b4782fb459e084549ed4cd4ead779764829b1d862148359eae5";
    armv7l-linux = "14f2ea0459f0dda8c566b0fa4a2fe755f4220bbae313ea0c453861ac2f803196";
    aarch64-linux = "80e05c1a0b51c335483666e959c1631a089246986b7fc3a4f9ee1288a57a602a";
  };

  electron_7 = mkElectron "7.1.10" {
    x86_64-linux = "296f034ac9a00afa4dc99ed145410c015af3f59cd7e9becc7709d70a4f8a9ebf";
    x86_64-darwin = "10eb453c2b19948777a6f404fbdbdd48464a4cd63db16bd3ce66b60dda016724";
    i686-linux = "681b6440d4f0f7ffa29a34610ef41103d72937d6e524d81fd2d0fa8d9eb67936";
    armv7l-linux = "2c09e9a77f1da152d766dc2e43719e2852b70f917229466a2ac457416d1374f7";
    aarch64-linux = "1dad780b872bbc069eb1cac9ff4ec8f0b8d200153ab7f51397e27219094db1f0";
  };

  electron_8 = mkElectron "8.0.0" {
    x86_64-linux = "b457a2ece83bb8a2efea42e75403740cbba051a64e325288760046b8999dd1c9";
    x86_64-darwin = "3f96dfa1d4e0313d11b9e5c66e2df161cfdb30685ee9dadcc779bcad2fb3876e";
    i686-linux = "0633ac2b6b6d00302e0e5df224d0e808e4ea9ecc14643e8534027e49b20436fb";
    armv7l-linux = "8d1f3daa86c77e7aceb8c8e4491c094e789951c7d475fc536b85fe7d279794bf";
    aarch64-linux = "484c04204478e8594d66f8bd332529c0c5eecfd71ee1705cc0478fa59c6818ee";
  };
}
