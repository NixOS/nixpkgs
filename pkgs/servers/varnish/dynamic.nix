{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  varnish,
  docutils,
  version,
  sha256,
}:

stdenv.mkDerivation {
  pname = "${varnish.name}-dynamic";
  inherit version;

  src = fetchFromGitHub {
    owner = "nigoroll";
    repo = "libvmod-dynamic";
    rev = "v${version}";
    inherit sha256;
  };

  nativeBuildInputs = [
    pkg-config
    docutils
    autoreconfHook
    varnish.python
  ];
  buildInputs = [ varnish ];
  postPatch = ''
    substituteInPlace Makefile.am --replace "''${LIBVARNISHAPI_DATAROOTDIR}/aclocal" "${varnish.dev}/share/aclocal"
  '';
  configureFlags = [ "VMOD_DIR=$(out)/lib/varnish/vmods" ];

  meta = {
    description = "Dynamic director similar to the DNS director from Varnish 3";
    homepage = "https://github.com/nigoroll/libvmod-dynamic";
    inherit (varnish.meta) license platforms teams;
  };
}
