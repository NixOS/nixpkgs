{ stdenv, lib, fetchPypi, python, buildPythonPackage, isPy38
, cython, bzip2, lzo, numpy, numexpr, hdf5, six, c-blosc, mock }:

with stdenv.lib;

buildPythonPackage rec {
  version = "3.6.0";
  pname = "tables";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k9xc0b49j311r6yayw7wzjay6ch3jznijhzc4x33yv490hqhd6v";
  };

  nativeBuildInputs = [ cython ];

  buildInputs = [ hdf5 bzip2 lzo c-blosc ];
  propagatedBuildInputs = [ numpy numexpr six mock ];

  # When doing `make distclean`, ignore docs
  postPatch = ''
    substituteInPlace Makefile --replace "src doc" "src"
  '';

  # Regenerate C code with Cython
  preBuild = ''
    make distclean
  '';

  # The setup script complains about missing run-paths, but they are
  # actually set.
  setupPyBuildFlags = [
    "--hdf5=${getDev hdf5}"
    "--lzo=${getDev lzo}"
    "--bzip2=${getDev bzip2}"
    "--blosc=${getDev c-blosc}"
  ];
  # Run the test suite.
  # It requires the build path to be in the python search path.
  # These tests take quite some time.
  # If the hdf5 library is built with zlib then there is only one
  # test-failure. That is the same failure as described in the following
  # github issue:
  #     https://github.com/PyTables/PyTables/issues/269
  checkPhase = ''
    ${python.interpreter} <<EOF
    import sysconfig
    import sys
    import os
    f = "lib.{platform}-{version[0]}.{version[1]}"
    lib = f.format(platform=sysconfig.get_platform(),
                   version=sys.version_info)
    build = os.path.join(os.getcwd(), 'build', lib)
    sys.path.insert(0, build)
    import tables
    r = tables.test()
    if not r.wasSuccessful():
        sys.exit(1)
    EOF
  '';

  # Disable tests until the failure described above is fixed.
  doCheck = false;

  meta = {
    description = "Hierarchical datasets for Python";
    homepage = http://www.pytables.org/;
    license = stdenv.lib.licenses.bsd2;
  };
}
