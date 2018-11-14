{ buildRubyGem, ruby }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "1.16.4";
  source.sha256 = "15zrxqv817w4vawc23lx3miigir36ba59wkykkr6l1nkf0iy013d";
  dontPatchShebangs = true;

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';
}
