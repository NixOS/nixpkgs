{ buildRubyGem, ruby }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "1.17.2";
  source.sha256 = "0dbnq6703mjvgsri45vaw7b4wjqr89z1h8xkzsacqcp24a706m5r";
  dontPatchShebangs = true;

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';
}
