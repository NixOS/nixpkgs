{ lib
, buildPythonPackage
, dataclasses-json
, fetchFromGitHub
, fetchpatch
, limiter
, pythonOlder
, requests
, responses
}:

buildPythonPackage rec {
  pname = "spyse-python";
  version = "2.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "spyse-com";
    repo = pname;
    rev = "v${version}";
    sha256 = "041k0037anwaxp2mh7mdk8rdsw9hdr3arigyyqfxfn35x8j41c3k";
  };

  propagatedBuildInputs = [
    requests
    dataclasses-json
    responses
    limiter
  ];

  # Tests requires an API token
  doCheck = false;

  patches = [
    # Update limiter import and rate limit, https://github.com/spyse-com/spyse-python/pull/11
    (fetchpatch {
      name = "support-later-limiter.patch";
      url = "https://github.com/spyse-com/spyse-python/commit/ff68164c514dfb28ab77d8690b3a5153962dbe8c.patch";
      hash = "sha256-PoWPJCK/Scsh4P7lr97u4JpVHXNlY0C9rJgY4TDYmv0=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'dataclasses~=0.6'," "" \
      --replace "responses~=0.13.3" "responses>=0.13.3" \
      --replace "limiter~=0.1.2" "limiter>=0.1.2" \
      --replace "requests~=2.26.0" "requests>=2.26.0"
  '';

  pythonImportsCheck = [
    "spyse"
  ];

  meta = with lib; {
    description = "Python module for spyse.com API";
    homepage = "https://github.com/spyse-com/spyse-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
