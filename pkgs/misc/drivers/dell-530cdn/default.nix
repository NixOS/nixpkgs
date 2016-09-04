{ runCommand, fetchurl, rpm, cpio }: let
  version = "1.3-1";

  src = fetchurl {
    url = "http://downloads.dell.com/printer/Dell-5130cdn-Color-Laser-${version}.noarch.rpm";
    md5 = "7fb7122e67e40b99deb9665d88df62d1";
  };
in runCommand "Dell-5130cdn-Color-Laser-1.3-1" {} ''
  mkdir -p usr/share/cups/model
  ${rpm}/bin/rpm2cpio ${src} | ${cpio}/bin/cpio -i
  mkdir -p $out/share/ppd
  mv usr/share/cups/model/Dell $out/share/ppd
''
