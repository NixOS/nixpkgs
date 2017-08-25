{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, varnish, libmhash, docutils }:

stdenv.mkDerivation rec {
  version = "1.0.1";
  name = "varnish-digest-${version}";

  src = fetchFromGitHub {
    owner = "varnish";
    repo = "libvmod-digest";
    rev = "libvmod-digest-${version}";
    sha256 = "0v18bqbsblhajpx5qvczic3psijhx5l2p2qlw1dkd6zl33hhppy7";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig docutils ];
  buildInputs = [ varnish libmhash ];

  postPatch = ''
    substituteInPlace autogen.sh  --replace "-I \''${dataroot}/aclocal"                  ""
    substituteInPlace Makefile.am --replace "-I \''${LIBVARNISHAPI_DATAROOTDIR}/aclocal" ""
  '';

  configureFlags = [ "VMOD_DIR=$(out)/lib/varnish/vmods" ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Digest and HMAC vmod";
    homepage = https://github.com/varnish/libvmod-digest;
    inherit (varnish.meta) license platforms maintainers;
  };
}
