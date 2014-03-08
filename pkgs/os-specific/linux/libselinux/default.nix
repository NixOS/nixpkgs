{ stdenv, fetchurl, pkgconfig, libsepol, pcre
, enablePython ? false, swig ? null, python ? null
}:

assert enablePython -> swig != null && python != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libselinux-${version}";
  version = "2.2.2";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/libselinux-${version}.tar.gz";
    sha256 = "0gjs5cqwhqzmf0avnn0343ip69153k9z35vbp03sjvc02qs3darh";
  };

  buildInputs = [ pkgconfig libsepol pcre ]
             ++ optionals enablePython [ swig python ];

  postPatch = optionalString enablePython ''
    sed -i -e 's|\$(LIBDIR)/libsepol.a|${libsepol}/lib/libsepol.a|' src/Makefile
  '';

  installFlags = [ "PREFIX=$(out)" "DESTDIR=$(out)" ];
  installTargets = [ "install" ] ++ optional enablePython "install-pywrap";

  # TODO: Figure out why the build incorrectly links libselinux.so
  postInstall = ''
    rm $out/lib/libselinux.so
    ln -s libselinux.so.1 $out/lib/libselinux.so
  '';

  meta = {
    inherit (libsepol.meta) homepage platforms maintainers;
  };
}
