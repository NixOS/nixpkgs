{ buildRubyGem, ruby }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "2.3.20";
  source.sha256 = "sha256-gJJ3vHzrJo6XpHS1iwLb77jd9ZB39GGLcOJQSrgaBHw=";
  dontPatchShebangs = true;

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';
}
