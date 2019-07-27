{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, glibcLocales
, mpmath
}:

buildPythonPackage rec {
  pname = "sympy";
  version = "1.4"; # Upgrades may break sage. Please test or ping @timokau.

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "sympy-${version}";
    sha256 = "0rpp82alvli7w3cab7h4dyydkk00nkc6nf3ph35kjywxpdnp3fsm";
  };

  propagatedBuildInputs = [
    mpmath
  ];

  patches = [
    # to be fixed by https://github.com/sympy/sympy/pull/13476
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/sympy/patches/03_undeffun_sage.patch?id=3277ba76d0ba7174608a31a0c6623e9210c63e3d";
      sha256 = "0xcp1qafvqnivvvi0byh51mbgqicjhmswwvqvamjz9rxfzm5f7d7";
    })
  ];

  meta = {
    description = "A Python library for symbolic mathematics";
    homepage    = http://www.sympy.org/;
    license     = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lovek323 timokau costrouc ];
  };
}
