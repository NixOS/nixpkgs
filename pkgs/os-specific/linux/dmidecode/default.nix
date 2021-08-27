{ lib, stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "dmidecode";
  version = "3.2";

  src = fetchurl {
    url = "mirror://savannah/dmidecode/dmidecode-${version}.tar.xz";
    sha256 = "1pcfhcgs2ifdjwp7amnsr3lq95pgxpr150bjhdinvl505px0cw07";
  };

  patches = [
    # suggested patches for 3.2 according to https://www.nongnu.org/dmidecode/
    (fetchpatch {
      name = "0001-fix_redfish_hostname_print_length.patch";
      url = "https://git.savannah.gnu.org/cgit/dmidecode.git/patch/?id=fde47bb227b8fa817c88d7e10a8eb771c46de1df";
      sha256 = "133nd0c72p68hnqs5m714167761r1pp6bd3kgbsrsrwdx40jlc3m";
    })
    (fetchpatch {
      name = "0002-add_logical_non-volatile_device_to_memory_device_types.patch";
      url = "https://git.savannah.gnu.org/cgit/dmidecode.git/patch/?id=74dfb854b8199ddb0a27e89296fa565f4706cb9d";
      sha256 = "0wdpmlcwmqdyyrsmyis8jb7cx3q6fnqpdpc5xly663dj841jcvwh";
    })
    (fetchpatch {
      name = "0003-only-scan-devmem-for-entry-point-on-x86.patch";
      url = "https://git.savannah.gnu.org/cgit/dmidecode.git/patch/?id=e12ec26e19e02281d3e7258c3aabb88a5cf5ec1d";
      sha256 = "1y2858n98bfa49syjinx911vza6mm7aa6xalvzjgdlyirhccs30i";
    })
    (fetchpatch {
      name = "0004-fix_formatting_of_tpm_table_output.patch";
      url = "https://git.savannah.gnu.org/cgit/dmidecode.git/patch/?id=1d0db85949a5bdd96375f6131d393a11204302a6";
      sha256 = "11s8jciw7xf2668v79qcq2c9w2gwvm3dkcik8dl9v74p654y1nr8";
    })
    (fetchpatch {
      name = "0005-fix_system-slot_information_for_pcie_ssd.patch";
      url = "https://git.savannah.gnu.org/cgit/dmidecode.git/patch/?id=fd08479625b5845e4d725ab628628f7ebfccc407";
      sha256 = "07l61wvsw1d8g14zzf6zm7l0ri9kkqz8j5n4h116qwhg1p2k49y4";
    })
    (fetchpatch {
      name = "0006-print_type_33_name_unconditionally.patch";
      url = "https://git.savannah.gnu.org/cgit/dmidecode.git/patch/?id=65438a7ec0f4cddccf810136da6f280bd148af71";
      sha256 = "0gqz576ccxys0c8217spf1qmw9lxi9xalw85jjqwsi2bj1k6vy4n";
    })
    (fetchpatch {
      name = "0007-dont_choke_on_invalid_processor_voltage.patch";
      url = "https://git.savannah.gnu.org/cgit/dmidecode.git/patch/?id=5bb7eb173b72256f70c6b3f3916d7a444be93340";
      sha256 = "1dkg4lq9kn2g1w5raz1gssn6zqk078zjqbnh9i32f822f727syhp";
    })
    (fetchpatch {
      name = "0008-fix_the_alignment_of_type_25_name.patch";
      url = "https://git.savannah.gnu.org/cgit/dmidecode.git/patch/?id=557c3c373a9992d45d4358a6a2ccf53b03276f39";
      sha256 = "18hc91pk7civyqrlilg3kn2nmp2warhh49xlbzrwqi7hgipyf12z";
    })
  ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    homepage = "https://www.nongnu.org/dmidecode/";
    description = "A tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
