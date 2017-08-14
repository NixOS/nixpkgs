{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "acpi-${version}";
  version = "1.7";

  src = fetchurl {
    url = "mirror://sourceforge/acpiclient/${version}/${name}.tar.gz";
    sha256 = "01ahldvf0gc29dmbd5zi4rrnrw2i1ajnf30sx2vyaski3jv099fp";
  };

  meta = with stdenv.lib; {
    description = "Show battery status and other ACPI information";
    longDescription = ''
      Linux ACPI client is a small command-line
      program that attempts to replicate the functionality of
      the "old" `apm' command on ACPI systems.  It includes
      battery and thermal information.
    '';
    homepage = https://sourceforge.net/projects/acpiclient/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.mornfall ];
  };
}
