{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkgconfig, varnish, libmaxminddb, docutils }:

stdenv.mkDerivation {
  pname = "${varnish.name}-geoip2";
  version = "2020-03-11";

  src = fetchFromGitHub {
    owner = "fgsch";
    repo = "libvmod-geoip2";
    rev = "c96a72bb1d403b361610befa015b29c6eeadce10";
    sha256 = "0727n5h6prngigpiykrrzpw94j64dh45b9vydnb9wvafm1g13ds4";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace autogen.sh  --replace "''${dataroot}/aclocal"         "${varnish.dev}/share/aclocal"
    substituteInPlace Makefile.am --replace "''${VARNISH_DATAROOT}/aclocal" "${varnish.dev}/share/aclocal"
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig docutils ];
  buildInputs = [ varnish libmaxminddb ];
  configureFlags = [ "VMOD_DIR=$(out)/lib/varnish/vmods" ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A Varnish master VMOD to query MaxMind GeoIP2 DB files";
    homepage = https://github.com/fgsch/libvmod-geoip2;
    inherit (varnish.meta) license platforms maintainers;
    broken = versionAtLeast varnish.version "6.2"; # tests crash with core dump
  };
}
