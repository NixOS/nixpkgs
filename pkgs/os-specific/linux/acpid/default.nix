{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "acpid-2.0.28";

  src = fetchurl {
    url = "mirror://sourceforge/acpid2/${name}.tar.xz";
    sha256 = "043igasvp1l6nv5rzh4sksmymay2qn20anl4zm4zvwnkn1a3l34q";
  };

  meta = with stdenv.lib; {
    homepage = http://tedfelix.com/linux/acpid-netlink.html;
    description = "A daemon for delivering ACPI events to userspace programs";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
