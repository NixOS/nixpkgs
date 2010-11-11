{stdenv, fetchurl, libcap}:

stdenv.mkDerivation rec{
  name = "lxc-0.7.3";

  src = fetchurl {
    url = "mirror://sourceforge/lxc/${name}.tar.gz";
    sha256 = "02fs90gj8vc3sls2kknqhdv8nk7r2k85slx8x8slfz4vnz6jhfzs";
  };

  patchPhase = ''
    sed -i -e '/ldconfig/d' src/lxc/Makefile.in
  '';

  configureFlags = [ "--localstatedir=/var" ];

  buildInputs = [ libcap ];

  meta = {
    homepage = http://lxc.sourceforge.net;
    description = "lxc Linux Containers userland tools";
    license = "LGPLv2.1+";
    platforms = stdenv.lib.platforms.linux;
  };
}
