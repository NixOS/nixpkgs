{ stdenv, fetchurl, pkgconfig, python, buildPythonApplication, parted, e2fsprogs }:

buildPythonApplication rec {
  name = "pyparted-${version}";
  version = "3.10";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/p/y/pyparted/${name}.tar.gz";
    sha256 = "17wq4invmv1nfazaksf59ymqyvgv3i8h4q03ry2az0s9lldyg3dv";
  };

  postPatch = ''
    sed -i -e 's|/sbin/mke2fs|${e2fsprogs}&|' tests/baseclass.py
    sed -i -e '
      s|e\.path\.startswith("/tmp/temp-device-")|"temp-device-" in e.path|
    ' tests/test__ped_ped.py
  '' + stdenv.lib.optionalString stdenv.isi686 ''
    # remove some integers in this test case which overflow on 32bit systems
    sed -i -r -e '/class *UnitGetSizeTestCase/,/^$/{/[0-9]{11}/d}' \
      tests/test__ped_ped.py
  '';

  preConfigure = ''
    PATH="${parted}/sbin:$PATH"
  '';

  buildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ parted ];

  checkPhase = ''
    patchShebangs Makefile
    make test PYTHON=${python.executable}
  '';

  meta = {
    homepage = https://fedorahosted.org/pyparted/;
    description = "Python interface for libparted";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
