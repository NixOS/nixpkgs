{ lib, stdenv, fetchurl, e2fsprogs, openldap, pkg-config }:

stdenv.mkDerivation rec {
  version = "4.06";
  pname = "quota";

  src = fetchurl {
    url = "mirror://sourceforge/linuxquota/quota-${version}.tar.gz";
    sha256 = "sha256-Lz4DA583jU8Nl6zbSdr1gdyq1k0uHd8SlJX9V5+9Jo0=";
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
