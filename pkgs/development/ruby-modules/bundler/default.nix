{ buildRubyGem, ruby }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "2.1.4";
  source.sha256 = "12glbb1357x91fvd004jgkw7ihlkpc9dwr349pd7j83isqhls0ah";
  dontPatchShebangs = true;

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';
}
