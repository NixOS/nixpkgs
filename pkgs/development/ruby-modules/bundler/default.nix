{ buildRubyGem, makeWrapper, ruby, coreutils }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "1.12.5";
  sha256 = "1q84xiwm9j771lpmiply0ls9l2bpvl5axn3jblxjvrldh8di2pkc";
  dontPatchShebangs = true;
}
