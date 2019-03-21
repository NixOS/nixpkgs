{ stdenv, fetchurl, liblockfile }:

stdenv.mkDerivation rec {
  _name   = "lockfile-progs";
  version = "0.1.18";
  name    = "${_name}-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/l/${_name}/${_name}_${version}.tar.gz";
    sha256 = "1rjwn3fh2hy8hmpr66y8yp7v5i3325v1mk0gr7pqhqbyp6j9aad4";
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
    license = stdenv.lib.licenses.gpl2;

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.all;
  };
}
