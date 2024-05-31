{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "vat-moss";
  version = "0.11.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "vat_moss-python";
    rev = version;
    hash = "sha256-c0lcyeW8IUhWKcfn3BmsbNmHyAzm8T0sdYp0Zp0FbFw=";
  };

  patches = [
    (fetchpatch {
      # Update API URL to HTTPS
      url = "https://github.com/raphaelm/vat_moss-python/commit/ed32b7d893da101332d3bb202d17b1bf89e5d9ed.patch";
      hash = "sha256-GpxaQ6/1LdFdxzXT/p4HS7FHU0WeM0i3LbdRFeqnFdw=";
    })
  ];

  pythonImportsCheck = [ "vat_moss" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [ "test_fetch" ];

  disabledTestPaths = [
    # network access
    "tests/test_id.py"
  ];

  meta = with lib; {
    description = "A Python library for dealing with VAT MOSS and Norway VAT on digital services. Includes VAT ID validation, rate calculation based on place of supply, exchange rate and currency tools for invoices";
    homepage = "https://github.com/raphaelm/vat_moss-python";
    changelog = "https://github.com/raphaelm/vat_moss-python/blob/${src.rev}/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
