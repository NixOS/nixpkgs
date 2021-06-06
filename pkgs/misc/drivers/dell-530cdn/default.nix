{ runCommand, fetchurl, rpm, cpio }: let
  version = "1.3-1";

  src = fetchurl {
    url = "http://downloads.dell.com/printer/Dell-5130cdn-Color-Laser-${version}.noarch.rpm";
    sha256 = "0pj32sj6jcdnpa5v75af0hnvx4z0ky0m1k2522cfdx4cb1r2lna9";
  };
in runCommand "Dell-5130cdn-Color-Laser-1.3-1" {} ''
  mkdir -p usr/share/cups/model
  ${rpm}/bin/rpm2cpio ${src} | ${cpio}/bin/cpio -i
  mkdir -p $out/share/ppd
  mv usr/share/cups/model/Dell $out/share/ppd
''
