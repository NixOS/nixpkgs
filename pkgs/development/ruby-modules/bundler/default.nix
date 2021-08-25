{ buildRubyGem, ruby }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "2.2.20";
  source.sha256 = "259ba486173d72a71df43fee8e3bc8dcb868c8a65e0c4020af3a6f13c3a57ff8";
  dontPatchShebangs = true;

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';
}
