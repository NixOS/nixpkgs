{ lib
, buildPythonPackage
, setuptools
, nftables
}:

buildPythonPackage {
  pname = "nftables";
  inherit (nftables) version src;
  pyproject = true;

  patches = [ ./fix-py-libnftables.patch ];

  postPatch = ''
    substituteInPlace "py/src/nftables.py" \
      --subst-var-by "out" "${nftables}"
  '';

  setSourceRoot = "sourceRoot=$(echo */py)";

  build-system = [ setuptools ];

  pythonImportsCheck = [ "nftables" ];

  meta = {
    inherit (nftables.meta) description homepage license platforms maintainers;
  };
}
