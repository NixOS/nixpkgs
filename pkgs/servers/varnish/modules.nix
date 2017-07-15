{ stdenv, fetchurl, pkgconfig, varnish, python, docutils }:

stdenv.mkDerivation rec {
  version = "0.10.2";
  name = "varnish-modules-${version}";

  src = fetchurl {
    url = "https://download.varnish-software.com/varnish-modules/varnish-modules-${version}.tar.gz";
    sha256 = "0inw76pm8kcidh0lq7gm3c3bh8v6yps0z7j6ar617b8wf730w1im";
  };

  nativeBuildInputs = [ pkgconfig docutils ];
  buildInputs = [ varnish python ];

  meta = with stdenv.lib; {
    description = "Collection of Varnish Cache modules (vmods) by Varnish Software";
    homepage = https://github.com/varnish/varnish-modules;
    inherit (varnish.meta) license platforms maintainers;
  };
}
