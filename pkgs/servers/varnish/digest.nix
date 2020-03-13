{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, varnish, libmhash, docutils }:

stdenv.mkDerivation {
  pname = "${varnish.name}-digest";
  version = "2019-09-27";

  src = {
    "6.0.5" = fetchFromGitHub {
      owner = "varnish";
      repo = "libvmod-digest";
      rev = "2b7f74b8897765372f2c7d7c760229bd8740fea2";  # https://github.com/varnish/libvmod-digest/commits/6.0
      sha256 = "1zpnj7wrhn3qia2jfzawb0kz0ryk2hxmky44dd12pz0yww04ig96";
    };
    "6.2.2" = fetchFromGitHub {
      owner = "varnish";
      repo = "libvmod-digest";
      rev = "2b7f74b8897765372f2c7d7c760229bd8740fea2";  # https://github.com/varnish/libvmod-digest/commits/6.2
      sha256 = "1zpnj7wrhn3qia2jfzawb0kz0ryk2hxmky44dd12pz0yww04ig96";
    };
    "6.3.1" = fetchFromGitHub {
      owner = "varnish";
      repo = "libvmod-digest";
      rev = "1793bea9e9b7c7dce4d8df82397d22ab9fa296f0";  # https://github.com/varnish/libvmod-digest/commits/6.3
      sha256 = "0n33g8ml4bsyvcvl5lk7yng1ikvmcv8dd6bc1mv2lj4729pp97nn";
    };
  }.${varnish.version};

  nativeBuildInputs = [ autoreconfHook pkgconfig docutils ];
  buildInputs = [ varnish libmhash ];

  postPatch = ''
    substituteInPlace autogen.sh  --replace "''${dataroot}/aclocal"                  "${varnish.dev}/share/aclocal"
    substituteInPlace Makefile.am --replace "''${LIBVARNISHAPI_DATAROOTDIR}/aclocal" "${varnish.dev}/share/aclocal"
  '';

  configureFlags = [ "VMOD_DIR=$(out)/lib/varnish/vmods" ];

  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Digest and HMAC vmod";
    homepage = https://github.com/varnish/libvmod-digest;
    inherit (varnish.meta) license platforms maintainers;
    broken = versionAtLeast varnish.version "6.2"; # tests crash with core dump
  };
}
