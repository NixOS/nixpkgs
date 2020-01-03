{ stdenv, fetchurl, ant, javac, hdf_java }:

stdenv.mkDerivation rec {
  pname = "hdfview";
  version = "2.14";

  src = fetchurl {
    url = "https://support.hdfgroup.org/ftp/HDF5/hdf-java/current/src/${pname}-${version}.tar.gz";
    sha256 = "0lv9djfm7hnp14mcyzbiax3xjb8vkbzhh7bdl6cvgy53pc08784p";
  };

  nativeBuildInputs = [ ant javac ];

  HDFLIBS = hdf_java;

  buildPhase = ''
    ant run
    ant package
  '';

  installPhase = ''
    mkdir $out
    # exclude jre
    cp -r build/HDF_Group/HDFView/*/{lib,share} $out/
    mkdir $out/bin
    cp -r build/HDF_Group/HDFView/*/hdfview.sh $out/bin/hdfview
    chmod +x $out/bin/hdfview
    substituteInPlace $out/bin/hdfview \
      --replace "@JAVABIN@" "${javac}/bin/" \
      --replace "@INSTALLDIR@" "$out"
  '';

  meta = {
    description = "A visual tool for browsing and editing HDF4 and HDF5 files";
    license = stdenv.lib.licenses.free; # BSD-like
    homepage = https://support.hdfgroup.org/products/java/index.html;
    platforms = stdenv.lib.platforms.linux;
  };
}
