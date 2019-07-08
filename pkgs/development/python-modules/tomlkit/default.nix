{ lib, buildPythonPackage, fetchPypi, isPy27, isPy34
, enum34, functools32, typing
}:

buildPythonPackage rec {
  pname = "tomlkit";
  version = "0.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pby2lbzwy2pwdbq8xaqi4560b1ih5m0y141mmbc446j3w168fvv";
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
