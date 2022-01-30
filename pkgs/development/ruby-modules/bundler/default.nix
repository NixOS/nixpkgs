{ buildRubyGem, ruby }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "2.2.33";
  source.sha256 = "0m06ywj0lq3ba2i7sdk7wsx8dfi94w3dkw8m7l2k54ix1pdx8vqa";
  dontPatchShebangs = true;

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';
}
