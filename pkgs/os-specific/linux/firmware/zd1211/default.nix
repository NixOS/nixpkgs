{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "zd1211-firmware";
  version = "1.5";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/zd1211/${name}.tar.bz2";
    sha256 = "04ibs0qw8bh6h6zmm5iz6lddgknwhsjq8ib3gyck6a7psw83h7gi";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib/firmware/zd1211
    cp * $out/lib/firmware/zd1211
  '';

  meta = {
    description = "Firmware for the ZyDAS ZD1211(b) 802.11a/b/g USB WLAN chip";
    homepage = http://sourceforge.net/projects/zd1211/;
    license = "GPL";
  };
}
