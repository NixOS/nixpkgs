{ lib
, buildPythonPackage
, setuptools
, nftables
}:

buildPythonPackage {
  pname = "nftables";
  inherit (nftables) version src meta;

  patches = [ ./fix-py-libnftables.patch ];

  postPatch = ''
    substituteInPlace "py/src/nftables.py" \
      --subst-var-by "out" "${nftables}"
  '';

  preConfigure = ''
    cd py
  '';

  nativeBuildInputs = [ setuptools ];

  pyproject = true;
  pythonImportsCheck = [ "nftables" ];
}
