{ buildRubyGem, ruby }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "2.2.24";
  source.sha256 = "1x3czmqhlyb593ap7mxkk47idi2jnbnrpwj8xlsjdpi7iair9y62";
  dontPatchShebangs = true;

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';
}
