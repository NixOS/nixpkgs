# Based on: https://github.com/tokiclover/bar-overlay/tree/ddd118f571a63160c0517e7108aefcbba79d969e/net-print/cnijfilter

{
  stdenv,
  fetchurl,
  autoconf,
  automake,
  libtool,
  pkg-config,
  rpmextract,
  glib,
  gtk2,
  popt,
  libxml2,
  libtiff,
  libpng,
  libusb1
}:
let
  mkDriverPackage = import ./generic.nix
    { inherit stdenv autoconf automake libtool glib; };
in {
  cnijfilter_2_60 = mkDriverPackage [
    { id = "256"; model = "ip2200"; }
    { id = "260"; model = "ip4200"; }
    { id = "265"; model = "ip6600d"; }
    { id = "266"; model = "ip7700"; }
    { id = "273"; model = "mp500"; }
  ] {
    version = "2.60";
    src = fetchurl {
      url = "http://gdlp01.c-wss.com/gds/3/0900007183/02/cnijfilter-common-2.60-4.src.rpm";
      sha256 = "13swb8rvcvn4wdlg6v2hn03dpi4fa05pr2xrq390yisxwnvkjr4f";
    };
    unpackCmd = ''
      rpmextract $src
      tar xvf cnijfilter-common-2.60-4.tar.gz
    '';
    patches = [
      ./patches/cnijfilter-2.60-1-png_jmpbuf-fix.patch
      ./patches/cnijfilter-2.60-1-pstocanonij.patch
      ./patches/cnijfilter-2.70-4-libxml2.patch
      ./patches/cnijfilter-2.60-1-canonip4200.ppd.patch
      ./patches/cnijfilter-3.70-1-libexec-cups.patch
      ./patches/cnijfilter-3.80-6-headers.patch
      ./patches/cnijfilter-3.00-6-cups-1.6.patch
    ];
    buildInputs = [ popt libtiff libpng ];
    nativeBuildInputs = [ rpmextract ];
    postSetup = ''
      PRINTER_SRC=(''${PRINTER_SRC/lgmon/stsmon})
    '';
  };

  cnijfilter_2_70 = mkDriverPackage [
    { id = "291"; model = "mp160"; }
    { id = "292"; model = "ip3300"; }
    { id = "293"; model = "mp510"; }
    { id = "294"; model = "ip4300"; }
    { id = "295"; model = "mp600"; }
    { id = "311"; model = "ip2500"; }
    { id = "312"; model = "ip1800"; }
    { id = "253"; model = "ip90"; }
  ] {
    version = "2.70";
    src = fetchurl {
      url = "http://gdlp01.c-wss.com/gds/5/0900007185/02/cnijfilter-common-2.70-2.src.rpm";
      sha256 = "1ypm94zvgv103478r20ql4rfs2wlhmq2ssfs1h68j5q50lswk70g";
    };
    unpackCmd = ''
      rpmextract $src
      tar xvf cnijfilter-common-2.70-2.tar.gz
    '';
    patches = [
      ./patches/cnijfilter-2.70-4-ppd.patch
      ./patches/cnijfilter-2.70-1-png_jmpbuf-fix.patch
      ./patches/cnijfilter-2.70-4-libxml2.patch
      ./patches/cnijfilter-3.70-1-libexec-cups.patch
      ./patches/cnijfilter-3.80-6-headers.patch
      ./patches/cnijfilter-3.00-6-cups-1.6.patch
    ];
    buildInputs = [ popt libtiff libpng ];
    nativeBuildInputs = [ rpmextract ];
  };

  cnijfilter_2_80 = mkDriverPackage [
    { id = "315"; model = "mp140"; }
    { id = "316"; model = "mp210"; }
    { id = "319"; model = "ip3500"; }
    { id = "328"; model = "mp520"; }
    { id = "326"; model = "ip4500"; }
    { id = "327"; model = "mp610"; }
  ] {
    version = "2.80";
    src = fetchurl {
      url = "http://gdlp01.c-wss.com/gds/1/0100000841/01/cnijfilter-common-2.80-1.tar.gz";
      sha256 = "1qb4kwi1j86vj0cr0rx71avks8x5nbzzlc5gykcc3pyfrz4malqp";
    };
    patches = [
      ./patches/cnijfilter-2.70-1-png_jmpbuf-fix.patch
      ./patches/cnijfilter-3.20-4-ppd.patch
      ./patches/cnijfilter-2.80-1-libexec-backend.patch
      ./patches/cnijfilter-3.70-1-libexec-cups.patch
      ./patches/cnijfilter-3.80-6-headers.patch
      ./patches/cnijfilter-3.00-6-cups-1.6.patch
    ];
    buildInputs = [ popt libtiff libpng ];
  };

  cnijfilter_2_90 = mkDriverPackage [
    { id = "303"; model = "ip100"; }
    { id = "331"; model = "ip2600"; }
  ] {
    version = "2.90";
    src = fetchurl {
      url = "http://gdlp01.c-wss.com/gds/2/0100001192/01/cnijfilter-common-2.90-1.tar.gz";
      sha256 = "1nsalni7r326ac1691m9y3pp1il8rnkp3m49j8xn9cl1mjsi6lyf";
    };
    patches = [
      ./patches/cnijfilter-2.70-1-png_jmpbuf-fix.patch
      ./patches/cnijfilter-2.80-1-libexec-backend.patch
      ./patches/cnijfilter-3.20-4-ppd.patch
      ./patches/cnijfilter-3.70-1-libexec-cups.patch
      ./patches/cnijfilter-3.80-6-headers.patch
      ./patches/cnijfilter-3.00-6-cups-1.6.patch
    ];
    buildInputs = [ popt libtiff libpng ];
  };

  cnijfilter_3_00 = mkDriverPackage [
    { id = "346"; model = "ip1900"; }
    { id = "333"; model = "ip3600"; }
    { id = "334"; model = "ip4600"; }
    { id = "342"; model = "mp190"; }
    { id = "341"; model = "mp240"; }
    { id = "338"; model = "mp540"; }
    { id = "336"; model = "mp630"; }
  ] {
    version = "3.00";
    src = fetchurl {
      url = "http://gdlp01.c-wss.com/gds/6/0100001606/01/cnijfilter-common-3.00-1.tar.gz";
      sha256 = "0vd5gpzi8zz62i1qd697hc7vrvy69ad8i2331rgyc0fqrg10kkzh";
    };
    patches = [
      ./patches/cnijfilter-3.20-4-ppd.patch
      ./patches/cnijfilter-3.40-4-libpng15.patch
      ./patches/cnijfilter-3.70-1-libexec-cups.patch
      ./patches/cnijfilter-3.00-1-libexec-backend.patch
      ./patches/cnijfilter-3.80-6-headers.patch
      ./patches/cnijfilter-3.00-6-cups-1.6.patch
    ];
    buildInputs = [ popt libtiff libpng ];
  };

  cnijfilter_3_10 = mkDriverPackage [
    { id = "347"; model = "mx860"; }
    { id = "348"; model = "mx320"; }
    { id = "349"; model = "mx330"; }
  ] {
    version = "3.10";
    src = fetchurl {
      url = "http://files.canon-europe.com/files/soft33571/software/cnijfilter-source-3.10-1.tar.gz";
      sha256 = "1xhrjdwvxrhs3a4snp3fwp6r04jx36pmss17csly0rp2i2f4az45";
    };
    patches = [
      ./patches/cnijfilter-3.20-4-ppd.patch
      ./patches/cnijfilter-3.40-4-libpng15.patch
      ./patches/cnijfilter-3.70-1-libexec-cups.patch
      ./patches/cnijfilter-3.70-1-libexec-backend.patch
      ./patches/cnijfilter-3.10-1-libdl.patch
      ./patches/cnijfilter-3.70-6-headers.patch
      ./patches/cnijfilter-3.80-6-headers.patch
      ./patches/cnijfilter-3.70-6-cups-1.6.patch
    ];
    buildInputs = [ popt libtiff libpng gtk2 pkg-config ];
  };

  cnijfilter_3_20 = mkDriverPackage [
    { id = "356"; model = "mp250"; }
    { id = "357"; model = "mp270"; }
    { id = "358"; model = "mp490"; }
    { id = "359"; model = "mp550"; }
    { id = "360"; model = "mp560"; }
    { id = "361"; model = "ip4700"; }
    { id = "362"; model = "mp640"; }
  ] {
    version = "3.20";
    src = fetchurl {
      url = "http://gdlp01.c-wss.com/gds/7/0100002367/01/cnijfilter-source-3.20-1.tar.gz";
      sha256 = "16hb3056dqmzhl6kqxqzs929zxf97nsf23la1kmvli36kpbxri1g";
    };
    patches = [
      ./patches/cnijfilter-3.20-1-libdl.patch
      ./patches/cnijfilter-3.20-4-ppd.patch
      ./patches/cnijfilter-3.40-4-libpng15.patch
      ./patches/cnijfilter-3.70-1-libexec-cups.patch
      ./patches/cnijfilter-3.70-1-libexec-backend.patch
      ./patches/cnijfilter-3.70-6-headers.patch
      ./patches/cnijfilter-3.80-6-headers.patch
      ./patches/cnijfilter-3.70-6-cups-1.6.patch
    ];
    buildInputs = [ popt libtiff libpng gtk2 pkg-config ];
  };

  cnijfilter_3_30 = mkDriverPackage [
    { id = "364"; model = "ip2700"; }
    { id = "365"; model = "mx340"; }
    { id = "366"; model = "mx350"; }
    { id = "367"; model = "mx870"; }
  ] {
    version = "3.30";
    src = fetchurl {
      url = "http://gdlp01.c-wss.com/gds/4/0100002724/01/cnijfilter-source-3.30-1.tar.gz";
      sha256 = "15p4pi85xxvp9g5s727m75m10ac8h71wpbsvnlm0vni9kpwrp7a2";
    };
    patches = [
      ./patches/cnijfilter-3.20-4-ppd.patch
      ./patches/cnijfilter-3.20-1-libdl.patch
      ./patches/cnijfilter-3.40-4-libpng15.patch
      ./patches/cnijfilter-3.70-1-libexec-cups.patch
      ./patches/cnijfilter-3.70-1-libexec-backend.patch
      ./patches/cnijfilter-3.80-1-cups-1.6.patch
      ./patches/cnijfilter-3.70-6-headers.patch
      ./patches/cnijfilter-3.80-6-headers.patch
      ./patches/cnijfilter-3.70-6-cups-1.6.patch
    ];
    buildInputs = [ popt libtiff libpng gtk2 pkg-config ];
  };

  cnijfilter_3_40 = mkDriverPackage [
    { id = "356"; model = "mp250"; }
    { id = "369"; model = "mp495"; }
    { id = "370"; model = "mp280"; }
    { id = "373"; model = "mg5100"; }
    { id = "374"; model = "mg5200"; }
    { id = "375"; model = "ip4800"; }
    { id = "376"; model = "mg6100"; }
    { id = "377"; model = "mg8100"; }
  ] {
    version = "3.40";
    src = fetchurl {
      url = "http://files.canon-europe.com/files/soft40245/software/cnijfilter-source-3.40-1.tar.gz";
      sha256 = "0ylapgzwrc51vlilmw4zv210ws049745rqsf7v68m7hs975d8pd9";
    };
    patches = [
      ./patches/cnijfilter-3.20-4-ppd.patch
      ./patches/cnijfilter-3.40-4-libpng15.patch
      ./patches/cnijfilter-3.70-5-abi_x86_32.patch
      ./patches/cnijfilter-3.70-1-libexec-cups.patch
      ./patches/cnijfilter-3.70-1-libexec-backend.patch
      ./patches/cnijfilter-3.70-1-libdl.patch
      ./patches/cnijfilter-3.80-1-cups-1.6.patch
      ./patches/cnijfilter-3.70-6-headers.patch
      ./patches/cnijfilter-3.80-6-headers.patch
      ./patches/cnijfilter-3.70-6-cups-1.6.patch
    ];
    buildInputs = [ popt libtiff libpng gtk2 pkg-config ];
    hardeningDisable = [ "format" ];
  };

  cnijfilter_3_50 = mkDriverPackage [
    { id = "380"; model = "mx360"; }
    { id = "381"; model = "mx410"; }
    { id = "382"; model = "mx420"; }
    { id = "383"; model = "mx880"; }
    { id = "384"; model = "ix6500"; }
  ] {
    version = "3.50";
    src = fetchurl {
      url = "http://files.canon-europe.com/files/soft40869/software/cnijfilter-source-3.50-1.tar.gz";
      sha256 = "18la8cl928sxli9lfy6yrf8xm7xd62w0ld5zx70bzz3562nhpc73";
    };
    patches = [
      ./patches/cnijfilter-3.20-4-ppd.patch
      ./patches/cnijfilter-3.20-4-libpng15.patch
      ./patches/cnijfilter-3.70-5-abi_x86_32.patch
      ./patches/cnijfilter-3.70-1-libexec-cups.patch
      ./patches/cnijfilter-3.70-1-libexec-backend.patch
      ./patches/cnijfilter-3.70-1-libdl.patch
      ./patches/cnijfilter-3.80-1-cups-1.6.patch
      ./patches/cnijfilter-3.80-6-headers.patch
      ./patches/cnijfilter-3.70-6-headers.patch
      ./patches/cnijfilter-3.70-6-cups-1.6.patch
    ];
    buildInputs = [ popt libtiff libpng gtk2 pkg-config ];
    hardeningDisable = [ "format" ];
  };

  cnijfilter_3_60 = mkDriverPackage [
    { id = "386"; model = "mg2100"; }
    { id = "387"; model = "mg3100"; }
    { id = "388"; model = "mg4100"; }
    { id = "389"; model = "mg5300"; }
    { id = "390"; model = "mg6200"; }
    { id = "391"; model = "mg8200"; }
    { id = "392"; model = "ip4900"; }
    { id = "393"; model = "e500"; }
  ] {
    version = "3.60";
    src = fetchurl {
      url = "http://gdlp01.c-wss.com/gds/8/0100003928/01/cnijfilter-source-3.60-1.tar.gz";
      sha256 = "1pl9lhcq2zg7j40cys90pcr61gcjp6x20sh4v9sjv8xzmsh92kvy";
    };
    patches = [
      ./patches/cnijfilter-3.20-4-ppd.patch
      ./patches/cnijfilter-3.20-4-libpng15.patch
      ./patches/cnijfilter-3.70-5-abi_x86_32.patch
      ./patches/cnijfilter-3.70-1-libexec-cups.patch
      ./patches/cnijfilter-3.70-1-libexec-backend.patch
      ./patches/cnijfilter-3.70-1-libdl.patch
      ./patches/cnijfilter-3.80-1-cups-1.6.patch
      ./patches/cnijfilter-3.80-6-headers.patch
      ./patches/cnijfilter-3.70-6-headers.patch
      ./patches/cnijfilter-3.70-6-cups-1.6.patch
    ];
    buildInputs = [ popt libtiff libpng gtk2 pkg-config ];
    hardeningDisable = [ "format" ];
  };

  cnijfilter_3_70 = mkDriverPackage [
    { id = "303"; model = "ip100"; }
    { id = "394"; model = "mx710"; }
    { id = "395"; model = "mx890"; }
    { id = "396"; model = "mx370"; }
    { id = "397"; model = "mx430"; }
    { id = "398"; model = "mx510"; }
    { id = "399"; model = "e600"; }
  ] {
    version = "3.70";
    src = fetchurl {
      url = "http://gdlp01.c-wss.com/gds/8/0100004118/01/cnijfilter-source-3.70-1.tar.gz";
      sha256 = "1ghhpkvlccbgfhgwm8jjwhj69vp8y3bawgk38apsy4dv4qcizmbb";
    };
    patches = [
      ./patches/cnijfilter-3.20-4-ppd.patch
      ./patches/cnijfilter-3.20-4-libpng15.patch
      ./patches/cnijfilter-3.70-5-abi_x86_32.patch
      ./patches/cnijfilter-3.70-1-libexec-cups.patch
      ./patches/cnijfilter-3.70-1-libexec-backend.patch
      ./patches/cnijfilter-3.70-1-libdl.patch
      ./patches/cnijfilter-3.80-1-cups-1.6.patch
      ./patches/cnijfilter-3.80-6-headers.patch
      ./patches/cnijfilter-3.70-6-headers.patch
      ./patches/cnijfilter-3.70-6-cups-1.6.patch
    ];
    buildInputs = [ gtk2 pkg-config popt libxml2 ];
  };

  cnijfilter_3_80 = mkDriverPackage [
    { id = "401"; model = "mp230"; }
    { id = "402"; model = "mg2200"; }
    { id = "403"; model = "e510"; }
    { id = "404"; model = "mg3200"; }
    { id = "405"; model = "mg4200"; }
    { id = "406"; model = "ip7200"; }
    { id = "407"; model = "mg5400"; }
    { id = "408"; model = "mg6300"; }
  ] {
    version = "3.80";
    src = fetchurl {
      url = "http://gdlp01.c-wss.com/gds/3/0100004693/01/cnijfilter-source-3.80-1.tar.gz";
      sha256 = "1ac6n2lm6bw2xq13zpbg33n8npj512m33z78br31j7qr327l0vcb";
    };
    patches = [
      ./patches/cnijfilter-3.20-4-ppd.patch
      ./patches/cnijfilter-3.20-4-libpng15.patch
      ./patches/cnijfilter-3.70-1-libexec-cups.patch
      ./patches/cnijfilter-3.70-1-libexec-backend.patch
      ./patches/cnijfilter-3.80-5-abi_x86_32.patch
      ./patches/cnijfilter-3.80-1-cups-1.6.patch
      ./patches/cnijfilter-3.80-6-headers.patch
      ./patches/cnijfilter-3.80-6-cups-1.6.patch
      ./patches/cnijfilter-3.70-6-headers.patch
      ./patches/cnijfilter-3.70-6-cups-1.6.patch
    ];
    buildInputs = [ gtk2 pkg-config popt libxml2 ];
  };

  cnijfilter_3_90 = mkDriverPackage [
    { id = "416"; model = "mx720"; }
    { id = "417"; model = "mx920"; }
    { id = "418"; model = "mx390"; }
    { id = "419"; model = "mx450"; }
    { id = "420"; model = "mx520"; }
    { id = "421"; model = "e660"; }
  ] {
    version = "3.90";
    src = fetchurl {
      url = "http://gdlp01.c-wss.com/gds/1/0100005171/01/cnijfilter-source-3.90-1.tar.gz";
      sha256 = "0vykrvfgfc76wg3dmv9cj80jblqi3vibg8xv91kvisgzd78lsb2g";
    };
    patches = [
      ./patches/cnijfilter-3.20-4-ppd.patch
      ./patches/cnijfilter-3.70-1-libexec-cups.patch
      ./patches/cnijfilter-3.70-1-libexec-backend.patch
      ./patches/cnijfilter-3.80-5-abi_x86_32.patch
      ./patches/cnijfilter-3.80-1-cups-1.6.patch
      ./patches/cnijfilter-3.90-6-headers.patch
      ./patches/cnijfilter-3.80-6-cups-1.6.patch
      ./patches/cnijfilter-3.70-6-headers.patch
      ./patches/cnijfilter-3.70-6-cups-1.6.patch
    ];
    buildInputs = [ gtk2 pkg-config popt libxml2 ];
  };

  cnijfilter_4_00 = mkDriverPackage [
    { id = "423"; model = "mg7100"; }
    { id = "424"; model = "mg6500"; }
    { id = "425"; model = "mg6400"; }
    { id = "426"; model = "mg5500"; }
    { id = "427"; model = "mg3500"; }
    { id = "428"; model = "mg2400"; }
    { id = "429"; model = "mg2500"; }
    { id = "430"; model = "p200"; }
  ] {
    version = "4.00";
    src = fetchurl {
      url = "http://gdlp01.c-wss.com/gds/5/0100005515/01/cnijfilter-source-4.00-1.tar.gz";
      sha256 = "1g02bmgw850qvhalyyayb1sziksrk2h542d0gjh15p947ixmc8pp";
    };
    patches = [
      ./patches/cnijfilter-4.00-4-ppd.patch
      ./patches/cnijfilter-3.70-1-libexec-cups.patch
      ./patches/cnijfilter-3.70-1-libexec-backend.patch
      ./patches/cnijfilter-4.00-1-libexec-backend.patch
      ./patches/cnijfilter-4.00-1-libexec-cups.patch
      ./patches/cnijfilter-4.00-5-abi_x86_32.patch
      ./patches/cnijfilter-3.80-1-cups-1.6.patch
      ./patches/cnijfilter-3.90-6-headers.patch
      ./patches/cnijfilter-3.80-6-cups-1.6.patch
      ./patches/cnijfilter-4.00-6-headers.patch
    ];
    buildInputs = [ gtk2 pkg-config popt libxml2 libusb1 ];
  };

  cnijfilter_4_10 = mkDriverPackage [
    { id = "431"; model = "ix6700"; }
    { id = "432"; model = "ix6800"; }
    { id = "433"; model = "ip2800"; }
    { id = "434"; model = "mx470"; }
    { id = "435"; model = "mx530"; }
    { id = "436"; model = "ip8700"; }
    { id = "437"; model = "e560"; }
    { id = "438"; model = "e400"; }
  ] {
    version = "4.10";
    src = fetchurl {
      url = "http://gdlp01.c-wss.com/gds/8/0100005858/01/cnijfilter-source-4.10-1.tar.gz";
      sha256 = "1665dza214r56aypp66931dhbnjxrfagnl3k5aqzxp44cvz3gzqc";
    };
    patches = [
      ./patches/cnijfilter-3.70-1-libexec-cups.patch
      ./patches/cnijfilter-3.70-1-libexec-backend.patch
      ./patches/cnijfilter-4.00-1-libexec-backend.patch
      ./patches/cnijfilter-4.00-1-libexec-cups.patch
      ./patches/cnijfilter-4.00-4-ppd.patch
      ./patches/cnijfilter-4.00-5-abi_x86_32.patch
      ./patches/cnijfilter-3.80-1-cups-1.6.patch
      ./patches/cnijfilter-3.90-6-headers.patch
      ./patches/cnijfilter-3.80-6-cups-1.6.patch
      ./patches/cnijfilter-4.00-6-headers.patch
    ];
    buildInputs = [ gtk2 pkg-config popt libxml2 libusb1 ];
  };
}
