{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, varnish, libmhash, docutils }:

stdenv.mkDerivation rec {
  version = "1.0.2";
  pname = "${varnish.name}-digest";

  src = fetchFromGitHub {
    owner = "varnish";
    repo = "libvmod-digest";
    rev = "libvmod-digest-${version}";
    sha256 = "0jwkqqalydn0pwfdhirl5zjhbc3hldvhh09hxrahibr72fgmgpbx";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config docutils ];
  buildInputs = [ varnish libmhash ];

  postPatch = ''
    substituteInPlace autogen.sh  --replace "''${dataroot}/aclocal"                  "${varnish.dev}/share/aclocal"
    substituteInPlace Makefile.am --replace "''${LIBVARNISHAPI_DATAROOTDIR}/aclocal" "${varnish.dev}/share/aclocal"
  '';

  configureFlags = [ "VMOD_DIR=$(out)/lib/varnish/vmods" ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated-declarations" ];

  doCheck = true;

  meta = with lib; {
    description = "Digest and HMAC vmod";
    homepage = "https://github.com/varnish/libvmod-digest";
    inherit (varnish.meta) license platforms maintainers;
  };
}
