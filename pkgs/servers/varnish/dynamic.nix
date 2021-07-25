{ lib, stdenv, fetchFromGitHub, autoreconfHook269, pkg-config, varnish, docutils }:

stdenv.mkDerivation rec {
  version = "0.4";
  pname = "${varnish.name}-dynamic";

  src = fetchFromGitHub {
    owner = "nigoroll";
    repo = "libvmod-dynamic";
    rev = "v${version}";
    sha256 = "1n94slrm6vn3hpymfkla03gw9603jajclg84bjhwb8kxsk3rxpmk";
  };

  nativeBuildInputs = [ pkg-config docutils autoreconfHook269 varnish.python ];
  buildInputs = [ varnish ];
  postPatch = ''
    substituteInPlace Makefile.am --replace "''${LIBVARNISHAPI_DATAROOTDIR}/aclocal" "${varnish.dev}/share/aclocal"
  '';
  configureFlags = [ "VMOD_DIR=$(out)/lib/varnish/vmods" ];

  meta = with lib; {
    description = "Dynamic director similar to the DNS director from Varnish 3";
    homepage = "https://github.com/nigoroll/libvmod-dynamic";
    inherit (varnish.meta) license platforms maintainers;
  };
}
