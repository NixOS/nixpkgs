{ lib, python3Packages, fetchFromGitHub, fetchpatch }:

python3Packages.buildPythonApplication rec {
  pname = "plecost";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "iniqua";
    repo = pname;
    # Release is untagged
    rev = "aa40e504bee95cf731f0cc9f228bcf5fdfbe6194";
    sha256 = "K8ESI2EOqH9zBDfSKgVcTKjCMdRhBiwltIbXDt1vF+M=";
  };

  patches = [
    # Fix compatibility with aiohttp 3.x
    # Merged - pending next release
    (fetchpatch {
      url = "https://github.com/iniqua/plecost/pull/34/commits/c09e7fab934f136f8fbc5f219592cf5fec151cf9.patch";
      sha256 = "sha256-G7Poo3+d+PQTrg8PCrmsG6nMHt8CXgiuAu+ZNvK8oiw=";
    })
  ];

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    async-timeout
    termcolor
    lxml
  ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Vulnerability fingerprinting and vulnerability finder for Wordpress blog engine";
    homepage = "https://github.com/iniqua/plecost";
    license = licenses.bsd3;
    maintainers = with maintainers; [ emilytrau ];
  };
}
