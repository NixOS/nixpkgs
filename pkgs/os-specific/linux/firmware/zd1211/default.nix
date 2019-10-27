{ stdenv, fetchzip }:

let
  pname = "zd1211-firmware";
  version = "1.5";
in fetchzip rec {
  name = "${pname}-${version}";
  url = "mirror://sourceforge/zd1211/${name}.tar.bz2";

  postFetch = ''
    tar -xjvf $downloadedFile
    mkdir -p $out/lib/firmware/zd1211
    cp zd1211-firmware/* $out/lib/firmware/zd1211
  '';

  sha256 = "0sj2zl3r0549mjz37xy6iilm1hm7ak5ax02gwrn81r5yvphqzd52";

  meta = {
    description = "Firmware for the ZyDAS ZD1211(b) 802.11a/b/g USB WLAN chip";
    homepage = https://sourceforge.net/projects/zd1211/;
    license = "GPL";
    platforms = stdenv.lib.platforms.linux;
  };
}
