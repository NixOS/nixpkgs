{ lib
, buildPythonPackage
, fetchPypi
, attrs
, pendulum
, pprintpp
, wrapt
}:

buildPythonPackage rec {
  pname = "tbm-utils";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v7pb3yirkhzbv1z5i1qp74vl880f56zvzfj68p08b5jxv64hmr3";
  };

  propagatedBuildInputs = [ attrs pendulum pprintpp wrapt ];

  # this versioning was done to prevent normal pip users from encountering
  # issues with package failing to build from source, but nixpkgs is better
  postPatch = ''
    substituteInPlace setup.py \
      --replace "'attrs>=18.2,<19.4'" "'attrs'"
  '';

  # No tests in archive.
  doCheck = false;

  meta = {
    description = "A commonly-used set of utilities";
    homepage = "https://github.com/thebigmunch/tbm-utils";
    license = with lib.licenses; [ mit ];
  };

}
