{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, gfortran
, perl
, pybind11
, bzip2
, numpy
  # Check Inputs
, pytestCheckHook
, pytestcov
}:

# TODO: replace w/ derivation, non-python
buildPythonPackage rec {
  pname = "xcfun";
  version = "1.X";
  src = fetchFromGitHub {
    owner = "dftlibs";
    repo = pname;
    rev = "stable-1.x"; # TODO
    sha256 = "0b53f11pr0xydiz6hqn0crymahkhrhh5yi96xr8gglj0j8rk7p1v";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    perl
    bzip2
  ];

  propagatedBuildInputs = [
    numpy
    pybind11
  ];

  cmakeFlags = [
    "-DBUILD_TESTING=ON"
  ];
  postConfigure = ''
    cd ..
  '';
  # setupPyBuildFlags = [
  #   "--cmake-options='-DENABLE_TESTALL=ON'"
  # ];
  # dontUseCmakeConfigure = true;
  # dontUseSetuptoolsBuild = true;
  preBuild = ''
    pushd build
    make
    popd
  '';

  checkInputs = [
    pytestCheckHook
    pytestcov
  ];
  dontUseSetuptoolsCheck = true;  # unittest doesn't know how to "test" built C libraries
  preCheck = ''
    # Run C tests
    # pushd ./testsuite
    # ctest
    # patchShebangs ./xc-run_testsuite
    # ./xc-run_testsuite
    # popd
    pushd build
    ctest --progress
    popd

    # Move compiled library to test dir
    cp ./dist/tmpbuild/pylibxc/pylibxc/libxc.so ./pylibxc/
  '';

  meta = with lib; {
    description = "Exchange-correlation functionals with arbitrary order derivatives";
    homepage = "https://xcfun.readthedocs.io/en/latest/";
    downloadPage = "https://github.com/dftlibs/xcfun/releases";
    license = licenses.mpl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
