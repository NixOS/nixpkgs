{ buildRubyGem, ruby }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "1.17.1";
  source.sha256 = "0jmj67r2677mq8hxkhvlgpbv8gzfgdhxra3x0gf0bywiyypl546c";
  dontPatchShebangs = true;

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';
}
