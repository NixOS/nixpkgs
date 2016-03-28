{ buildRubyGem, makeWrapper, ruby, coreutils }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "1.11.2";
  sha256 = "0s37j1hyngc4shq0in8f9y1knjdqkisdg3dd1mfwgq7n1bz8zan7";
  dontPatchShebangs = true;
}
