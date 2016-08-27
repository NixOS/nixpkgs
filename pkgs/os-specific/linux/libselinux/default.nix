{ stdenv, fetchurl, fetchpatch, pkgconfig, libsepol, pcre
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

  # Unreleased upstream patch that fixes Python package issue arising
  # from recent SWIG changes.
  patches = optional enablePython (fetchpatch {
    name = "fix-python-swig.patch";
    url = "https://github.com/SELinuxProject/selinux/commit/a9604c30a5e2f71007d31aa6ba41cf7b95d94822.patch";
    sha256 = "0mjrclh0sd8m7vq0wvl6pg29ss415j3kn0266v8ixy4fprafagfp";
    stripLen = 1;
  });

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
