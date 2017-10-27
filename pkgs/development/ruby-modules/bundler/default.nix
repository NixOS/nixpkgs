{ buildRubyGem, makeWrapper, ruby, coreutils }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "1.15.4";
  sha256 = "0wl4r7wbwdq68xidfv4hhzfb1spb6lmhbspwlzrg4pf1l6ipxlgs";
  dontPatchShebangs = true;

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';
}
