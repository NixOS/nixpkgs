{ lib, stdenv, fetchurl, pkg-config, python, buildPythonApplication, parted, e2fsprogs }:

buildPythonApplication rec {
  pname = "pyparted";
  version = "3.10";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/p/y/pyparted/${pname}-${version}.tar.gz";
    sha256 = "17wq4invmv1nfazaksf59ymqyvgv3i8h4q03ry2az0s9lldyg3dv";
  };

  postPatch = ''
    sed -i -e 's|/sbin/mke2fs|${e2fsprogs}&|' tests/baseclass.py
    sed -i -e '
      s|e\.path\.startswith("/tmp/temp-device-")|"temp-device-" in e.path|
    ' tests/test__ped_ped.py
  '' + lib.optionalString stdenv.isi686 ''
    # remove some integers in this test case which overflow on 32bit systems
    sed -i -r -e '/class *UnitGetSizeTestCase/,/^$/{/[0-9]{11}/d}' \
      tests/test__ped_ped.py
  '';

  preConfigure = ''
    PATH="${parted}/sbin:$PATH"
  '';

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [ parted ];

  checkPhase = ''
    patchShebangs Makefile
    make test PYTHON=${python.executable}
  '';

  meta = with lib; {
    homepage = "https://fedorahosted.org/pyparted/";
    description = "Python interface for libparted";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
