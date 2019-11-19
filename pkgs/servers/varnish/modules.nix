{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, varnish, docutils, removeReferencesTo }:

stdenv.mkDerivation rec {
  version = "0.15.0";
  name = "${varnish.name}-modules-${version}";

  src = fetchFromGitHub {
    owner = "varnish";
    repo = "varnish-modules";
    rev = version;
    sha256 = "00p9syl765lfg1d2ka7da6h46dfl388f8h36x9cmrjix95rg0yr8";
  };

  nativeBuildInputs = [
    autoreconfHook
    docutils
    pkgconfig
    removeReferencesTo
    varnish.python  # use same python version as varnish server
  ];

  buildInputs = [ varnish ];

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
