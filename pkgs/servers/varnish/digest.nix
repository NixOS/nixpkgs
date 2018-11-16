{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, varnish, libmhash, docutils }:

stdenv.mkDerivation rec {
  version = "1.0.2";
  name = "${varnish.name}-digest-${version}";

  src = fetchFromGitHub {
    owner = "varnish";
    repo = "libvmod-digest";
    rev = "libvmod-digest-${version}";
    sha256 = "0jwkqqalydn0pwfdhirl5zjhbc3hldvhh09hxrahibr72fgmgpbx";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig docutils ];
  buildInputs = [ varnish libmhash ];

  postPatch = ''
    substituteInPlace autogen.sh  --replace "''${dataroot}/aclocal"                  "${varnish.dev}/share/aclocal"
    substituteInPlace Makefile.am --replace "''${LIBVARNISHAPI_DATAROOTDIR}/aclocal" "${varnish.dev}/share/aclocal"
  '';

  configureFlags = [ "VMOD_DIR=$(out)/lib/varnish/vmods" ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Digest and HMAC vmod";
    homepage = https://github.com/varnish/libvmod-digest;
    inherit (varnish.meta) license platforms maintainers;
  };
}
