{ stdenv, fetchurl, pkgconfig, varnish, python, docutils, removeReferencesTo }:

stdenv.mkDerivation rec {
  version = "0.13.0";
  name = "varnish-modules-${version}";

  src = fetchurl {
    url = "https://download.varnish-software.com/varnish-modules/varnish-modules-${version}.tar.gz";
    sha256 = "1nj52va7cp0swcv87zd3si80knpaa4a7na37cy9wkvgyvhf9k8mh";
  };

  nativeBuildInputs = [ pkgconfig docutils removeReferencesTo ];
  buildInputs = [ varnish python ];

  postInstall = "find $out -type f -exec remove-references-to -t ${varnish.dev} '{}' +"; # varnish.dev captured only as __FILE__ in assert messages

  meta = with stdenv.lib; {
    description = "Collection of Varnish Cache modules (vmods) by Varnish Software";
    homepage = https://github.com/varnish/varnish-modules;
    inherit (varnish.meta) license platforms maintainers;
  };
}
