{stdenv, fetchurl, libcap}:

stdenv.mkDerivation rec{
  name = "lxc-0.7.5";

  src = fetchurl {
    url = "http://lxc.sf.net/download/lxc/${name}.tar.gz";
    sha256 = "019ec63f250c874bf7625b1f1bf555b1a6e3a947937a4fca73100abddf829b1c";
  };

  patchPhase = ''
    sed -i -e '/ldconfig/d' src/lxc/Makefile.in
  '';

  configureFlags = [ "--localstatedir=/var" ];

  postInstall = '' 
    cd "$out/lib"
    lib=liblxc.so.?.*
    ln -s $lib $(echo $lib | sed -re 's/(liblxc[.]so[.].)[.].*/\1/')
  '';

  buildInputs = [ libcap ];

  meta = {
    homepage = http://lxc.sourceforge.net;
    description = "lxc Linux Containers userland tools";
    license = "LGPLv2.1+";
    platforms = stdenv.lib.platforms.linux;
  };
}
