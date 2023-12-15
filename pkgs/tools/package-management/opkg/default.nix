{ lib
, stdenv
, fetchurl
, pkg-config
, curl
, gpgme
, libarchive
, bzip2
, xz
, attr
, acl
, libxml2
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "opkg";
  version = "0.6.2";

  src = fetchurl {
    url = "https://downloads.yoctoproject.org/releases/opkg/opkg-${version}.tar.gz";
    hash = "sha256-rHOpCiVJzQSUjlY9kVkSx44bi6D0OvdcWlP8ykdK29U=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    curl
    gpgme
    libarchive
    bzip2
    xz
    attr
    acl
    libxml2
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  meta = with lib; {
    description = "A lightweight package management system based upon ipkg";
    homepage = "https://git.yoctoproject.org/cgit/cgit.cgi/opkg/";
    changelog = "https://git.yoctoproject.org/opkg/tree/NEWS?h=v${version}";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
