{ lib
, boto3
, buildPythonPackage
, fetchFromGitHub
, humanize
, matrix-synapse-unwrapped
, pythonOlder
, tqdm
, twisted
, psycopg2
}:

buildPythonPackage rec {
  pname = "matrix-synapse-s3-storage-provider";
  version = "1.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "synapse-s3-storage-provider";
    rev = "refs/tags/v${version}";
    hash = "sha256-92Xkq54jrUE2I9uVOxI72V9imLNU6K4JqDdOZb+4f+Y=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "humanize>=0.5.1,<0.6" "humanize>=0.5.1"
  '';

  buildInputs = [
    matrix-synapse-unwrapped
  ];

  propagatedBuildInputs = [
    boto3
    humanize
    tqdm
    twisted
    psycopg2
  ]
  # For the s3_media_upload script
  ++ matrix-synapse-unwrapped.propagatedBuildInputs;

  # Tests need network access
  doCheck = false;

  pythonImportsCheck = [
    "s3_storage_provider"
  ];

  meta = with lib; {
    description = "Synapse storage provider to fetch and store media in Amazon S3";
    homepage = "https://github.com/matrix-org/synapse-s3-storage-provider";
    changelog = "https://github.com/matrix-org/synapse-s3-storage-provider/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ yuka ];
  };
}
