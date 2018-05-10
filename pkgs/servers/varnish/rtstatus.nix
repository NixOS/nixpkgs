{ stdenv, fetchurl, pkgconfig, varnish, python, docutils }:

stdenv.mkDerivation rec {
  version = "1.2.0";
  name = "${varnish.name}-rtstatus-${version}";

  src = fetchurl {
    url = "https://download.varnish-software.com/libvmod-rtstatus/libvmod-rtstatus-${version}.tar.gz";
    sha256 = "0hll1aspgpv1daw5sdbn5w1d6birchxgapzb6zi1nhahjlimy4ly";
  };

  nativeBuildInputs = [ pkgconfig docutils ];
  buildInputs = [ varnish python ];
  configureFlags = [ "VMOD_DIR=$(out)/lib/varnish/vmods" ];

  meta = with stdenv.lib; {
    description = "Varnish realtime status page";
    homepage = https://github.com/varnish/libvmod-rtstatus;
    inherit (varnish.meta) license platforms maintainers;
  };
}
