{ stdenv, fetchurl, fetchpatch, xproto, libX11, libXext, libXrandr }:
stdenv.mkDerivation rec {
  name = "slock-1.4";
  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "0sif752303dg33f14k6pgwq2jp1hjyhqv6x4sy3sj281qvdljf5m";
  };
  patches = [
    (fetchpatch {
      url = "http://s1m0n.dft-labs.eu/files/slock/slock.c.patch";
      addPrefixes = true;
      sha256 = "1g79y8yi04lnw9pyydxjh5hrw6cyqg2l0h5nv8qz62w844n4psi6";
    })
  ];
  buildInputs = [ xproto libX11 libXext libXrandr ];
  installFlags = "DESTDIR=\${out} PREFIX=";
  meta = with stdenv.lib; {
    homepage = http://tools.suckless.org/slock;
    description = "Simple X display locker";
    longDescription = ''
      Simple X display locker. This is the simplest X screen locker.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.linux;
  };
}
