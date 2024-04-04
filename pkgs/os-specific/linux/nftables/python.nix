{ buildPythonPackage
, nftables-c
, setuptools
}:

buildPythonPackage {
  inherit (nftables-c) pname version src;

  setSourceRoot = "sourceRoot=$(echo */py)";
  postPatch = ''
    substituteInPlace src/nftables.py \
      --replace libnftables.so.1 ${nftables-c}/lib/libnftables.so.1
  '';
  format = "pyproject";
  nativeBuildInputs = [ setuptools ];
  buildInputs = [ nftables-c ];

  meta = {
    inherit (nftables-c.meta) description homepage license platforms maintainers;
  };
}
