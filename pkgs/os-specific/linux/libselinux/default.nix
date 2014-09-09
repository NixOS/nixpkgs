{ stdenv, fetchurl, pkgconfig, libsepol, pcre
, enablePython ? false, swig ? null, python ? null
}:

assert enablePython -> swig != null && python != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libselinux-${version}";
  version = "2.3";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/libselinux-${version}.tar.gz";
    sha256 = "1ckpiv6m5c07rp5vawlhv02w5rq8kc0n95fh2ckq2jnqxi1hn7hb";
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
