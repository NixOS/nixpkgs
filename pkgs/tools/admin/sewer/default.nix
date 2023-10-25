{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "sewer";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s8f0w6nv8dcs5yw7rn49981b3c9mnnx4f6wzqw4zha0rpp60z22";
  };

  propagatedBuildInputs = with python3Packages; [ pyopenssl requests tldextract ];

  meta = with lib; {
    homepage = "https://github.com/komuw/sewer";
    description = "ACME client";
    license = licenses.mit;
    maintainers = with maintainers; [ kevincox ];
  };
}
