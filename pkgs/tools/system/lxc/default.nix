{ stdenv, fetchurl, libcap, perl }:

let
  name = "lxc-0.7.5";
in
stdenv.mkDerivation{
  inherit name;

  src = fetchurl {
    url = "http://lxc.sf.net/download/lxc/${name}.tar.gz";
    sha256 = "019ec63f250c874bf7625b1f1bf555b1a6e3a947937a4fca73100abddf829b1c";
  };

  buildInputs = [ libcap perl ];

  patchPhase = "sed -i -e 's|/sbin/ldconfig|:|' src/lxc/Makefile.in";

  configureFlags = "--localstatedir=/var";

  postInstall = ''
    cd "$out/lib"
    lib=liblxc.so.?.*
    ln -s $lib $(echo $lib | sed -re 's/(liblxc[.]so[.].)[.].*/\1/')
  '';

  meta = {
    homepage = http://lxc.sourceforge.net;
    description = "lxc Linux Containers userland tools";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
