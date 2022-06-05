{ lib, stdenv, fetchurl, pkg-config, curl, gpgme, libarchive, bzip2, xz, attr, acl, libxml2
, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "0.4.5";
  pname = "opkg";
  src = fetchurl {
    url = "https://downloads.yoctoproject.org/releases/opkg/opkg-${version}.tar.gz";
    sha256 = "sha256-oSFKdfo0+5Io242kcwjg5xGxyT/Yk4zxZMEP0o61Dx4=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ curl gpgme libarchive bzip2 xz attr acl libxml2 ];

  meta = with lib; {
    description = "A lightweight package management system based upon ipkg";
    homepage = "https://git.yoctoproject.org/cgit/cgit.cgi/opkg/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
