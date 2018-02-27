{ buildRubyGem, makeWrapper, ruby, coreutils }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "1.16.1";
  source.sha256 = "42b8e0f57093e1d10c15542f956a871446b759e7969d99f91caf3b6731c156e8";
  dontPatchShebangs = true;

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';
}
