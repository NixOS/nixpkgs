{
  buildPythonPackage,
  setuptools,
  nftables,
}:

buildPythonPackage {
  pname = "nftables";
  inherit (nftables) version src;
  pyproject = true;

  postPatch = ''
    substituteInPlace "src/nftables.py" \
      --replace-fail "libnftables.so.1" "${nftables}/lib/libnftables.so.1"
  '';

  setSourceRoot = "sourceRoot=$(echo */py)";

  build-system = [ setuptools ];

  pythonImportsCheck = [ "nftables" ];

  meta = {
    inherit (nftables.meta)
      description
      homepage
      license
      platforms
      maintainers
      ;
  };
}
