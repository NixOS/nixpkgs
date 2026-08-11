{
  buildPythonPackage,
  setuptools,
  nftables,
}:

buildPythonPackage (finalAttrs: {
  pname = "nftables";
  inherit (nftables) version src;
  pyproject = true;

  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace "src/nftables.py" \
      --replace-fail 'NFTABLES_VERSION = "0.1"' 'NFTABLES_VERSION = "${finalAttrs.version}"' \
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
})
