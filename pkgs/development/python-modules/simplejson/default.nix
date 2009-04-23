{ fetchsvn, stdenv, python, setuptools }:

stdenv.mkDerivation rec {
  name = "simplejson-2.0.9";

  src = fetchsvn {
    url = "http://simplejson.googlecode.com/svn/tags/${name}";
    sha256 = "a48d5256fdb4f258c33da3dda110ecf3c786f086dcb08a01309acde6d1ddb921";
    rev = "172";  # to be on the safe side
  };

  buildInputs = [ python ];
  propagatedBuildInputs = [ setuptools ];

  doCheck = true;

  buildPhase     = "python setup.py build --build-base $out";
  checkPhase     = "python setup.py test";

  installPhase   = ''
    ensureDir "$out/lib/python2.5/site-packages"

    PYTHONPATH="$out/lib/python2.5/site-packages:$PYTHONPATH" \
    python setup.py install --prefix="$out"

    # Remove irrelevant directories.
    rm -rvf "$out/"lib.* "$out/"temp.*
  '';

  meta = {
    description = "simplejson is a simple, fast, extensible JSON encoder/decoder for Python";

    longDescription = ''
      simplejson is compatible with Python 2.4 and later with no
      external dependencies.  It covers the full JSON specification
      for both encoding and decoding, with unicode support.  By
      default, encoding is done in an encoding neutral fashion (plain
      ASCII with \uXXXX escapes for unicode characters).
    '';

    homepage = http://code.google.com/p/simplejson/;

    license = "MIT";
  };
}
