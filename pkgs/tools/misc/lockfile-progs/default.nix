{ stdenv, fetchurl, liblockfile }:

stdenv.mkDerivation rec {
  _name   = "lockfile-progs";
  version = "0.1.16";
  name    = "${_name}-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/l/${_name}/${_name}_${version}.tar.gz";
    sha256 = "0sca19mg0lk68ms6idy4vfp8dyjpcbq9f143v9qzjyk86bb34lgr";
  };

  buildInputs = [ liblockfile ];

  installPhase = ''
    mkdir -p $out/bin $out/man/man1
    install -s bin/* $out/bin
    install man/*.1 $out/man/man1
  '';

  meta = {
    description = "Programs for locking and unlocking files and mailboxes";
    homepage = http://packages.debian.org/sid/lockfile-progs;
    license = "GPLv2";

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.all;
  };
}
