{ lib, stdenv, fetchurl, e2fsprogs, openldap, pkg-config }:

stdenv.mkDerivation rec {
  version = "4.05";
  pname = "quota";

  src = fetchurl {
    url = "mirror://sourceforge/linuxquota/quota-${version}.tar.gz";
    sha256 = "1fbsrxhhf1ls7i025db7p66yzjr0bqa2c63cni217v8l21fmnfzg";
  };

  outputs = [ "out" "dev" "doc" "man" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ e2fsprogs openldap ];

  meta = with lib; {
    description = "Tools to manage kernel-level quotas in Linux";
    homepage = "https://sourceforge.net/projects/linuxquota/";
    license = licenses.gpl2; # With some files being BSD as an exception
    platforms = platforms.linux;
    maintainers = [ maintainers.dezgeg ];
  };
}
