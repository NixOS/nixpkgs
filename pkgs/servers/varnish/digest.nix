{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  varnish,
  libmhash,
  docutils,
  coreutils,
  version,
  sha256,
}:

stdenv.mkDerivation rec {
  pname = "${varnish.name}-digest";
  inherit version;

  src = fetchFromGitHub {
    owner = "varnish";
    repo = "libvmod-digest";
    rev = version;
    inherit sha256;
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    docutils
  ];
  buildInputs = [
    varnish
    libmhash
  ];

  postPatch = ''
    substituteInPlace autogen.sh  --replace "''${dataroot}/aclocal"                  "${varnish.dev}/share/aclocal"
    substituteInPlace Makefile.am --replace "''${LIBVARNISHAPI_DATAROOTDIR}/aclocal" "${varnish.dev}/share/aclocal"
  '';

  configureFlags = [ "VMOD_DIR=$(out)/lib/varnish/vmods" ];

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=deprecated-declarations" ];

  doCheck = true;

  meta = with lib; {
    description = "Digest and HMAC vmod";
    homepage = "https://github.com/varnish/libvmod-digest";
    inherit (varnish.meta) license platforms teams;
  };
}
