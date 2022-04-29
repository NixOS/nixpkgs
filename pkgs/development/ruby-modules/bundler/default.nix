{ buildRubyGem, ruby }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "2.3.9";
  source.sha256 = "sha256-VZiKuSDP3sSoBXUPcPmwHR/GbZs47NIF+ZlXtHSZWzg=";
  dontPatchShebangs = true;

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';
}
