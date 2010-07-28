{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "acpi-0.09";
  
  src = fetchurl {
    url = "http://grahame.angrygoats.net/source/acpi/${name}.tar.gz";
    sha256 = "11iwzbm3gcn9ljvxl4cjj9fc1n135hx45rhrsprnnkqppndf3vn1";
  };

  meta = {
    longDescription = ''
      Linux ACPI client is a small command-line
      program that attempts to replicate the functionality of
      the "old" `apm' command on ACPI systems.  It includes
      battery and thermal information.
    '';
    homepage = http://grahame.angrygoats.net/acpi.shtml;
    license = "GPLv2+";
  };
}
