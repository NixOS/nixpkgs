{ stdenv, fetchurl, liblockfile }:

stdenv.mkDerivation rec {
  _name   = "lockfile-progs";
  version = "0.1.17";
  name    = "${_name}-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/l/${_name}/${_name}_${version}.tar.gz";
    sha256 = "04f5cvhrld15w58wkg6k2azywszsc5xp9cbmfx4jylwrak90byq3";
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
