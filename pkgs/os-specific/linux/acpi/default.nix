{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "acpi-${version}";
  version = "1.6";

  src = fetchurl {
    url = "mirror://sf/acpiclient/${version}/${name}.tar.gz";
    sha256 = "0cawznhkzb51yxa599d1xkw05nklmjrrmd79vmjkkzf4002d4qgd";
  };

  meta = {
    longDescription = ''
      Linux ACPI client is a small command-line
      program that attempts to replicate the functionality of
      the "old" `apm' command on ACPI systems.  It includes
      battery and thermal information.
    '';
    homepage = http://sourceforge.net/projects/acpiclient/;
    license = "GPLv2+";
  };
}
