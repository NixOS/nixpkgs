{ stdenv, libXScrnSaver, makeWrapper, fetchurl, wrapGAppsHook, glib, gtk3, unzip, atomEnv, libuuid, at-spi2-atk, at-spi2-core }@args:

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

  electron_7 = mkElectron "7.3.0" {
    x86_64-linux = "5841d2dae8633ddec654574507689a61983acd774e6cdc8774a64b26eb41b5d4";
    x86_64-darwin = "dfe6aeda73b71aa016fb87f5fdbf87f7d8e574f1cf318fc2a5543399b4e975ae";
    i686-linux = "fdcedc8fda7c3580dadfa50d2ffcf9ebde4d7a01b0a36fb799703510e3a7811f";
    armv7l-linux = "b2989bab1be05230364c058fbadf9967b23873d24e24ac3f7c8d013c11ed73e4";
    aarch64-linux = "15a70ae79aabbf6bb9ee8a107fd08ddc1021c534679899f88e1fcc8d4de980fe";
  };

  electron_8 = mkElectron "8.0.0" {
    x86_64-linux = "b457a2ece83bb8a2efea42e75403740cbba051a64e325288760046b8999dd1c9";
    x86_64-darwin = "3f96dfa1d4e0313d11b9e5c66e2df161cfdb30685ee9dadcc779bcad2fb3876e";
    i686-linux = "0633ac2b6b6d00302e0e5df224d0e808e4ea9ecc14643e8534027e49b20436fb";
    armv7l-linux = "8d1f3daa86c77e7aceb8c8e4491c094e789951c7d475fc536b85fe7d279794bf";
    aarch64-linux = "484c04204478e8594d66f8bd332529c0c5eecfd71ee1705cc0478fa59c6818ee";
  };
}
