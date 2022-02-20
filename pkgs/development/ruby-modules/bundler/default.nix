{ buildRubyGem, ruby }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "2.3.6";
  source.sha256 = "1531z805j3gls2x0pqp2bp1vv1rf5k7ynjl4qk72h8lpm1skqk9r";
  dontPatchShebangs = true;

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';
}
