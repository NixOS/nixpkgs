{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, varnish, docutils }:

stdenv.mkDerivation rec {
  version = "0.4";
  name = "${varnish.name}-dynamic-${version}";

  src = fetchFromGitHub {
    owner = "nigoroll";
    repo = "libvmod-dynamic";
    rev = "v${version}";
    sha256 = "1n94slrm6vn3hpymfkla03gw9603jajclg84bjhwb8kxsk3rxpmk";
  };

  nativeBuildInputs = [ pkgconfig docutils autoreconfHook varnish.python ];
  buildInputs = [ varnish ];
  postPatch = ''
    substituteInPlace Makefile.am --replace "''${LIBVARNISHAPI_DATAROOTDIR}/aclocal" "${varnish.dev}/share/aclocal"
  '';
  configureFlags = [ "VMOD_DIR=$(out)/lib/varnish/vmods" ];

  meta = with stdenv.lib; {
    description = "Dynamic director similar to the DNS director from Varnish 3";
    homepage = "https://github.com/nigoroll/libvmod-dynamic";
    inherit (varnish.meta) license platforms maintainers;
  };
}
