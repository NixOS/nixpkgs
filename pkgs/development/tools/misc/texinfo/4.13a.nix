{ stdenv, fetchurl, texinfo, ncurses, xz, autoconf }:

stdenv.mkDerivation rec {
  pname = "texinfo";
  version = "4.13a";

  src = fetchurl {
    url = "mirror://gnu/texinfo/${pname}-${version}.tar.lzma";
    sha256 = "1rf9ckpqwixj65bw469i634897xwlgkm5i9g2hv3avl6mv7b0a3d";
  };

  autoconfSrc = autoconf.src;

  # We need texinfo4 to build documentation of GNU m4, and version of
  # config.guess bundled in texinfo4 is too old to recognize some CI
  # platforms (see #172225).
  #
  # Using autoreconfHook results in infinity recursion.
  postPatch = ''
    tar xf $autoconfSrc
    cp -v ./autoconf-*/build-aux/config.guess ./build-aux/config.guess
  '';

  buildInputs = [ ncurses ];
  nativeBuildInputs = [ xz ];

  # Disabled because we don't have zdiff in the stdenv bootstrap.
  #doCheck = true;

  meta = texinfo.meta // { branch = version; };
}
