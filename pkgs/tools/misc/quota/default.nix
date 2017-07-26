{ stdenv, fetchurl, e2fsprogs, openldap, pkgconfig }:

stdenv.mkDerivation rec {
  version = "4.03";
  name = "quota-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/linuxquota/quota-${version}.tar.gz";
    sha256 = "0jv7vhxhjp3gc4hwgmrhg448sbzzqib80gdas9nm0c5zwyd4sv4w";
  };

  outputs = [ "out" "dev" "doc" "man" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ e2fsprogs openldap ];

  meta = with stdenv.lib; {
    description = "Tools to manage kernel-level quotas in Linux";
    homepage = http://sourceforge.net/projects/linuxquota/;
    license = licenses.gpl2; # With some files being BSD as an exception
    platforms = platforms.linux;
    maintainers = [ maintainers.dezgeg ];
  };
}
