{ buildRubyGem, ruby }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "1.17.3";
  source.sha256 = "0ln3gnk7cls81gwsbxvrmlidsfd78s6b2hzlm4d4a9wbaidzfjxw";
  dontPatchShebangs = true;

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';
}
