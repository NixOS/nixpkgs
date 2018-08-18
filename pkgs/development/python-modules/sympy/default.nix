{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, glibcLocales
, mpmath
}:

buildPythonPackage rec {
  pname = "sympy";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ac5b57691bc43919dcc21167660a57cc51797c28a4301a6144eff07b751216a4";
  };

  checkInputs = [ glibcLocales ];

  propagatedBuildInputs = [ mpmath ];

  # Bunch of failures including transients.
  doCheck = false;

  preCheck = ''
    export LANG="en_US.UTF-8"
  '';

  patches = [
    # see https://trac.sagemath.org/ticket/20204 and https://github.com/sympy/sympy/issues/12825
    # There is also an upstream patch for this, included in the next release (PR #128826).
    # However that doesn't quite fix the issue yet. Apparently some changes by sage are required.
    # TODO re-evaluate the change once a new sympy version is released (open a sage trac ticket about
    # it).
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/sympy/patches/03_undeffun_sage.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "1mh2va1rlgizgvx8yzqwgvbf5wvswarn511002b361mc8yy0bnhr";
    })
    (fetchpatch {
      url = "https://github.com/sympy/sympy/pull/13276.patch";
      sha256 = "1rz74b5c74vwh3pj9axxgh610i02l3555vvsvr4a15ya7siw7zxh";
    })
  ];

  meta = {
    description = "A Python library for symbolic mathematics";
    homepage    = http://www.sympy.org/;
    license     = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lovek323 ];
  };
}
