args: with args;

stdenv.mkDerivation rec {
  name = "acpitool-0.4.7";
  src = fetchurl {
    url = "mirror://sourceforge/acpitool/${name}.tar.bz2";
    sha256 = "133bdgcq9ql0l940kp9m2v6wzdvkyv8f1dizwjbx7v96n8g2c239";
  };


  meta = {
    description = ''ACPI Tool is a small, convenient command-line
                    ACPI client with a lot of features for Linux.'';
    homepage = http://freeunix.dyndns.org:8000/site2/acpitool.shtml;
    license = "GPLv2+";
  };
}
