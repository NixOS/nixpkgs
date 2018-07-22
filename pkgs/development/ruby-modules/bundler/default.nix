{ buildRubyGem, ruby }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "1.16.2";
  source.sha256 = "3bb53e03db0a8008161eb4c816ccd317120d3c415ba6fee6f90bbc7f7eec8690";
  dontPatchShebangs = true;

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';
}
