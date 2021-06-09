{ lib, buildPythonPackage, fetchFromBitbucket, isPy3k, nose }:

buildPythonPackage rec {
  pname = "tempita";
  version = "0.5.3";

  src = fetchFromBitbucket {
    owner = "ianb";
    repo = pname;
    rev = "97392d008cc8";
    sha256 = "10jz1n2qwz8vcfh68xya2jlazd7p9dn2790q4w0k5kagd4h25f07";
  };

  buildInputs = [ nose ];

  # When this library is installed by pip, it runs 2to3 automatically to make it compatible with Python3.
  # Nix doesn't follow the same approach and doesn't seem to respect setuptools build arguments `use_2to3=True`
  # (see https://bitbucket.org/ianb/tempita/src/97392d008cc8819afb99583f4d40c18ab9990082/setup.py#lines-39),
  # so we need to run this step manually before the build phase.
  preBuild = lib.optionalString isPy3k ''
    2to3 -w -n .
  '';

  meta = {
    homepage = "https://bitbucket.org/ianb/tempita";
    description = "A very small text templating language";
    license = lib.licenses.mit;
  };
}
