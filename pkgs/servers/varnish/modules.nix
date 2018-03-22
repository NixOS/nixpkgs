{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, varnish, python, docutils, removeReferencesTo }:

stdenv.mkDerivation rec {
  version = "0.14.0";
  name = "${varnish.name}-modules-${version}";

  src = fetchFromGitHub {
    owner = "varnish";
    repo = "varnish-modules";
    rev = version;
    sha256 = "17fkbr4i70qgdqsrx1x28ag20xkfyz1v3q3d3ywmv409aczqhm40";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook docutils removeReferencesTo ];
  buildInputs = [ varnish python ];

  postPatch = ''
    substituteInPlace bootstrap   --replace "''${dataroot}/aclocal"                  "${varnish.dev}/share/aclocal"
    substituteInPlace Makefile.am --replace "''${LIBVARNISHAPI_DATAROOTDIR}/aclocal" "${varnish.dev}/share/aclocal"
  '';

  postInstall = "find $out -type f -exec remove-references-to -t ${varnish.dev} '{}' +"; # varnish.dev captured only as __FILE__ in assert messages

  meta = with stdenv.lib; {
    description = "Collection of Varnish Cache modules (vmods) by Varnish Software";
    homepage = https://github.com/varnish/varnish-modules;
    inherit (varnish.meta) license platforms maintainers;
  };
}
