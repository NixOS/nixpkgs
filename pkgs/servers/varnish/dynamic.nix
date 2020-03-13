{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, varnish, docutils }:

stdenv.mkDerivation {
  pname = "${varnish.name}-dynamic";
  version = "2019-10-10";

  src = {
    "6.0.5" = fetchFromGitHub {
      owner = "nigoroll";
      repo = "libvmod-dynamic";
      rev = "b72c723acff5b2ef46c9de8cef036cee3a380a64"; # https://github.com/nigoroll/libvmod-dynamic/commits/6.0
      sha256 = "0gknnyfv0srf1gagl887mk0ibmj1aj96d6yyq27p2wylwckzqymi";
    };
    "6.2.2" = fetchFromGitHub {
      owner = "nigoroll";
      repo = "libvmod-dynamic";
      rev = "4070f9f3f114630630e1a99c2bb9007856a31f39"; # https://github.com/nigoroll/libvmod-dynamic/commits/6.2
      sha256 = "0m01hyjy80n4xzpjlzvmk8nw8bzj3cdraiirkz7klanpjgj7i74f";
    };
    "6.3.1" = fetchFromGitHub {
      owner = "nigoroll";
      repo = "libvmod-dynamic";
      rev = "71820eb7f91ad7e87755d02e522893a9e12dd55b"; # https://github.com/nigoroll/libvmod-dynamic/commits/master
      sha256 = "1i2d77qzrfcax9l39b1cmk809ksly22p43x51ij8pgl55674lffy";
    };
  }.${varnish.version};

  nativeBuildInputs = [ pkgconfig docutils autoreconfHook varnish.python ];
  buildInputs = [ varnish ];
  postPatch = ''
    substituteInPlace Makefile.am --replace "''${LIBVARNISHAPI_DATAROOTDIR}/aclocal" "${varnish.dev}/share/aclocal"
  '';
  configureFlags = [ "VMOD_DIR=$(out)/lib/varnish/vmods" ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Dynamic director similar to the DNS director from Varnish 3";
    homepage = https://github.com/nigoroll/libvmod-dynamic;
    inherit (varnish.meta) license platforms maintainers;
    broken = versionAtLeast varnish.version "6.2"; # tests crash with core dump
  };
}
