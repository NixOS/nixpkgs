{stdenv, fetchurl, libcap}:

stdenv.mkDerivation rec{
  name = "lxc-0.7.4";

  src = fetchurl {
    url = "mirror://sourceforge/lxc/${name}.tar.gz";
    sha256 = "a8237b2a42a05266a39aa9f9d64d7aa6f12b197cf1982d7764a0b0f9b940eef6";
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
