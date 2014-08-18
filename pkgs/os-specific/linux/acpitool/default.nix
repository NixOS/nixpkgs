{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "acpitool-0.5.1";
  
  src = fetchurl {
    url = "mirror://sourceforge/acpitool/${name}.tar.bz2";
    sha256 = "004fb6cd43102918b6302cf537a2db7ceadda04aef2e0906ddf230f820dad34f";
  };

  meta = {
    description = "A small, convenient command-line ACPI client with a lot of features";
    homepage = http://freeunix.dyndns.org:8000/site2/acpitool.shtml;
    license = "GPLv2+";
    maintainers = [ stdenv.lib.maintainers.guibert ];
  };
}
