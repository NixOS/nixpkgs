{ stdenv, fetchurl, pkgconfig, libsepol, pcre
, enablePython ? true, swig ? null, python ? null
}:

assert enablePython -> swig != null && python != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libselinux-${version}";
  version = "2.4";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/libselinux-${version}.tar.gz";
    sha256 = "0yqg73ns97jwjh1iyv0jr5qxb8k5sqq5ywfkx11lzfn5yj8k0126";
  };

  buildInputs = [ pkgconfig libsepol pcre ]
             ++ optionals enablePython [ swig python ];

  NIX_CFLAGS_COMPILE = "-fstack-protector-all -std=gnu89";

  postPatch = optionalString enablePython ''
    sed -i -e 's|\$(LIBDIR)/libsepol.a|${libsepol}/lib/libsepol.a|' src/Makefile
  '';

  preBuild = ''
    # Build fails without this precreated
    mkdir -p $out/include

    makeFlagsArray+=("PREFIX=$out")
    makeFlagsArray+=("DESTDIR=$out")
  '';

  installTargets = [ "install" ] ++ optional enablePython "install-pywrap";

  meta = libsepol.meta // {
    description = "SELinux core library";
  };
}
