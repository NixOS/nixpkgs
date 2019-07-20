{ lib, buildPythonPackage, fetchPypi, isPy27, isPy34
, enum34, functools32, typing
}:

buildPythonPackage rec {
  pname = "tomlkit";
  version = "0.5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xlmx280mzd3f63ydqhr76whbr2lhcwihyg9my9d5hjklkrhdn58";
  };

  propagatedBuildInputs =
    lib.optionals isPy27 [ enum34 functools32 ]
    ++ lib.optional (isPy27 || isPy34) typing;

  # The Pypi tarball doesn't include tests, and the GitHub source isn't
  # buildable until we bootstrap poetry, see
  # https://github.com/NixOS/nixpkgs/pull/53599#discussion_r245855665
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/sdispater/tomlkit;
    description = "Style-preserving TOML library for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
