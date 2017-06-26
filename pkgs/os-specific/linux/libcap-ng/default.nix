{ stdenv, fetchurl, swig ? null, python2 ? null, python3 ? null }:

assert python2 != null || python3 != null -> swig != null;

stdenv.mkDerivation rec {
  name = "libcap-ng-${version}";
  # When updating make sure to test that the version with
  # all of the python bindings still works
  version = "0.7.8";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.gz";
    sha256 = "0pyhjxgsph3p28ayk4ynxab6wvzaqmazk1nkamx11m2w8jbzj6n2";
  };

  nativeBuildInputs = [ swig ];
  buildInputs = [ python2 python3 ];

  postPatch = ''
    function get_header() {
      echo -e "#include <$1>" | gcc -M -xc - | tr ' ' '\n' | grep "$1" | head -n 1
    }

    # Fix some hardcoding of header paths
    sed -i "s,/usr/include/linux/capability.h,$(get_header linux/capability.h),g" bindings/python{,3}/Makefile.in
  '';

  configureFlags = [
    (if python2 != null then "--with-python" else "--without-python")
    (if python3 != null then "--with-python3" else "--without-python3")
  ];

  meta = let inherit (stdenv.lib) platforms licenses maintainers; in {
    description = "Library for working with POSIX capabilities";
    homepage = http://people.redhat.com/sgrubb/libcap-ng/;
    platforms = platforms.linux;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ wkennington ];
  };
}
