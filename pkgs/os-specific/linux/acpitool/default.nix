{lib, stdenv, fetchurl, fetchpatch}:

let
   acpitool-patch-051-4 = params: fetchpatch rec {
     inherit (params) name sha256;
     url = "https://salsa.debian.org/debian/acpitool/raw/33e2ef42a663de820457b212ea2925e506df3b88/debian/patches/${name}";
   };

in stdenv.mkDerivation rec {
  pname = "acpitool";
  version = "0.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/acpitool/acpitool-${version}.tar.bz2";
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
    description = "Small, convenient command-line ACPI client with a lot of features";
    mainProgram = "acpitool";
    homepage = "https://sourceforge.net/projects/acpitool/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.guibert ];
    platforms = lib.platforms.unix;
  };
}
