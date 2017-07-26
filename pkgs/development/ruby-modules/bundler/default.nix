{ buildRubyGem, makeWrapper, ruby, coreutils }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "1.15.1";
  sha256 = "1mq0n8g08vf2rnd7fvylx3f4sspx15abid49gycf9zzsjj7w8vps";
  dontPatchShebangs = true;

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';
}
