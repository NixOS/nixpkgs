{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, glibcLocales
, mpmath
}:

buildPythonPackage rec {
  pname = "sympy";
  version = "1.4"; # Upgrades may break sage. Please test or ping @timokau.

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q937csy8rd18pk2fz1ssj7jyj7l3rjx4nzbiz5vcymfhrb1x8bi";
  };

  checkInputs = [ glibcLocales ];

  propagatedBuildInputs = [ mpmath ];

  # tests take ~1h
  doCheck = false;

  patches = [
    # to be fixed by https://github.com/sympy/sympy/pull/13476
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/sympy/patches/03_undeffun_sage.patch?id=3277ba76d0ba7174608a31a0c6623e9210c63e3d";
      sha256 = "0xcp1qafvqnivvvi0byh51mbgqicjhmswwvqvamjz9rxfzm5f7d7";
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
