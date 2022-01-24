{ lib, buildPythonPackage, fetchPypi, isPy27
, enum34, functools32, typing ? null
}:

buildPythonPackage rec {
  pname = "tomlkit";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d7a454f319a7e9bd2e249f239168729327e4dd2d27b17dc68be264ad1ce36754";
  };

  propagatedBuildInputs =
    lib.optionals isPy27 [ enum34 functools32 ]
    ++ lib.optional isPy27 typing;

  # The Pypi tarball doesn't include tests, and the GitHub source isn't
  # buildable until we bootstrap poetry, see
  # https://github.com/NixOS/nixpkgs/pull/53599#discussion_r245855665
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/sdispater/tomlkit";
    description = "Style-preserving TOML library for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
