{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, glibcLocales
, mpmath
}:

buildPythonPackage rec {
  pname = "sympy";
  version = "1.3"; # Upgrades may break sage. Please test or ping @timokau.

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m0vhyv15zszn19mk5xq3py4iijjbr7f3fpy1s57b8q7c9arncg1";
  };

  checkInputs = [ glibcLocales ];

  propagatedBuildInputs = [ mpmath ];

  # some tests fail: https://github.com/sympy/sympy/issues/15149
  doCheck = false;

  patches = [
    # to be fixed by https://github.com/sympy/sympy/pull/13476
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/sympy/patches/03_undeffun_sage.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "1mh2va1rlgizgvx8yzqwgvbf5wvswarn511002b361mc8yy0bnhr";
    })
  ];

  preCheck = ''
    export LANG="en_US.UTF-8"
  '';

  meta = {
    description = "A Python library for symbolic mathematics";
    homepage    = http://www.sympy.org/;
    license     = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lovek323 timokau ];
  };
}
