{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "boost-build-2.0-m12";

  src = fetchurl {
    url = "mirror://sourceforge/boost/${name}.tar.bz2";
    sha256 = "10sbbkx2752r4i1yshyp47nw29lyi1p34sy6hj7ivvnddiliayca";
  };

  hardeningDisable = [ "format" ];

  patchPhase = ''
    grep -r '/usr/share/boost-build' \
      | awk '{split($0,a,":"); print a[1];}' \
      | xargs sed -i "s,/usr/share/boost-build,$out/share/boost-build,"
  '';

  buildPhase = ''
    cd jam_src
    ./build.sh
  '';

  installPhase = ''
    # Install Bjam
    mkdir -p $out/bin
    cd "$(ls | grep bin)"
    cp -a bjam $out/bin

    # Bjam is B2
    ln -s bjam $out/bin/b2

    # Install the shared files (don't include jam_src)
    cd ../..
    rm -rf jam_src
    mkdir -p $out/share
    cp -a . $out/share/boost-build
  '';

  meta = with stdenv.lib; {
    homepage = http://www.boost.org/boost-build2/;
    license = stdenv.lib.licenses.boost;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
