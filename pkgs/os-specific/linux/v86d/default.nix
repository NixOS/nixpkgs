{stdenv, fetchurl, klibc, kernel, withKlibc ? true}:

stdenv.mkDerivation rec {
  name = "v86d-0.1.10-${kernel.version}";

  src = fetchurl {
    url = "http://dev.gentoo.org/~spock/projects/uvesafb/archive/${name}.tar.bz2";
    sha256 = "0p3kwqjis941pns9948dxfnjnl5lwd8f2b6x794whs7g32p68jb3";
  };

  buildInputs = stdenv.lib.optional withKlibc klibc;

  configurePhase = ''
    bash ./configure $configureFlags
  '';

  configureFlags = if withKlibc then [ "--with-klibc" ] else [ "--default" ];

  makeFlags = [
    "KDIR=${kernel}/lib/modules/${kernel.modDirVersion}/source"
    "DESTDIR=$(out)"
  ];

  meta = {
    description = "A userspace helper that runs x86 code in an emulated environment";
    homepage = http://dev.gentoo.org/~spock/projects/uvesafb/;
    license = "BSD";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}

