{ stdenv, fetchurl, autoreconfHook, e2fsprogs }:

stdenv.mkDerivation rec {
  name = "tmpreaper-${version}";
  version = "1.6.17";

  src = fetchurl {
    url = "https://deb.debian.org/debian/pool/main/t/tmpreaper/tmpreaper_${version}.orig.tar.gz";
    sha256 = "1ca94d156eb68160ec9b6ed8b97d70fbee996de21437f0cf7d0c3b46709fecbc";
  };

  homepage = "https://packages.debian.org/sid/tmpreaper";
  license = "GPL-2.0-only";

  dependsBuild = [ autoreconfHook ];
  dependsRun = [ e2fsprogs ];

  buildInputs = [ autoreconfHook ];

  preConfigure = ''
    autoreconf -vfi
  '';

  configureFlags = [ "--prefix=${prefix}" "--sysconfdir=${etc}" ];

  doCheck = true;

  meta = {
    description = "Clean up files in directories based on their age";
    homepage = homepage;
    license = license;
    platforms = [ "x86_64-linux" "aarch64-linux" "darwin" ];
  };
}
