{ stdenv, fetchurl, glibc, doxygen, check }:

let
  name = "ding-libs";
  version = "0.5.0";
in stdenv.mkDerivation {
  inherit name;
  inherit version;

  src = fetchurl {
    url = "https://fedorahosted.org/released/${name}/${name}-${version}.tar.gz";
    sha256 = "dab937537a05d7a7cbe605fdb9b3809080d67b124ac97eb321255b35f5b172fd";
  };

  enableParallelBuilding = true;
  buildInputs = [ glibc doxygen check ];

  preConfigure = ''
    configureFlags="--prefix=/ --disable-static"
  '';

  buildPhase = ''
    cd "$NIX_BUILD_TOP/$name-$version"
    make all docs
  '';

  doCheck = true;
  checkPhase = ''
    cd "$NIX_BUILD_TOP/$name-$version"
    make check
  '';

  installPhase = ''
    cd "$NIX_BUILD_TOP/$name-$version"
    make DESTDIR="$out/" install
  '';

  meta = {
    description = "'D is not GLib' utility libraries";
    homepage = https://fedorahosted.org/sssd/;
    maintainers = with stdenv.lib.maintainers; [ benwbooth ];
    license = [ stdenv.lib.licenses.gpl3 stdenv.lib.licenses.lgpl3 ];
  };
}
