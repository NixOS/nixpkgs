{stdenv, fetchurl, fetchpatch}:

let
   acpitool-patch-051-4 = params: fetchpatch rec {
     inherit (params) name sha256;
     url = "https://anonscm.debian.org/cgit/pkg-acpi/acpitool.git/plain/debian/patches/${name}?h=debian/0.5.1-4&id=3fd9f396f12ec9c1cae3337a2a25026b7faad2ae";
   };

in stdenv.mkDerivation rec {
  name = "acpitool-0.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/acpitool/${name}.tar.bz2";
    sha256 = "004fb6cd43102918b6302cf537a2db7ceadda04aef2e0906ddf230f820dad34f";
  };

  patches = [
    (acpitool-patch-051-4 {
      name = "ac_adapter.patch";
      sha256 = "0rn14vfv9x5gmwyvi6bha5m0n0pm4wbpg6h8kagmy3i1f8lkcfi8";
    })
    (acpitool-patch-051-4 {
      name = "battery.patch";
      sha256 = "190msm5cgqgammxp1j4dycfz206mggajm5904r7ifngkcwizh9m7";
    })
    (acpitool-patch-051-4 {
      name = "kernel3.patch";
      sha256 = "1qb47iqnv09i7kgqkyk9prr0pvlx0yaip8idz6wc03wci4y4bffg";
    })
    (acpitool-patch-051-4 {
      name = "wakeup.patch";
      sha256 = "1mmzf8n4zsvc7ngn51map2v42axm9vaf8yknbd5amq148sjf027z";
    })
    (acpitool-patch-051-4 {
      name = "0001-Do-not-assume-fixed-line-lengths-for-proc-acpi-wakeu.patch";
      sha256 = "10wwh7l3jbmlpa80fzdr18nscahrg5krl18pqwy77f7683mg937m";
    })
    (acpitool-patch-051-4 {
      name = "typos.patch";
      sha256 = "1178fqpk6sbqp1cyb1zf9qv7ahpd3pidgpid3bbpms7gyhqvvdpa";
    })
  ];

  meta = {
    description = "A small, convenient command-line ACPI client with a lot of features";
    homepage = http://freeunix.dyndns.org:8000/site2/acpitool.shtml;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.guibert ];
  };
}
