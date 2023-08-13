{ lib, buildPythonPackage, fetchFromGitHub, matrix-synapse, twisted, humanize, boto3, tqdm }:

buildPythonPackage rec {
  pname = "matrix-synapse-s3-storage-provider";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "synapse-s3-storage-provider";
    rev = "v${version}";
    sha256 = "sha256-92Xkq54jrUE2I9uVOxI72V9imLNU6K4JqDdOZb+4f+Y=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "humanize>=0.5.1,<0.6" "humanize>=0.5.1"
  '';

  doCheck = false;
  pythonImportsCheck = [ "s3_storage_provider" ];

  buildInputs = [ matrix-synapse ];
  propagatedBuildInputs = [ twisted humanize boto3 tqdm ]
    # for the s3_media_upload script
    ++ matrix-synapse.propagatedBuildInputs;

  meta = with lib; {
    description = "Synapse storage provider to fetch and store media in Amazon S3";
    homepage = "https://github.com/matrix-org/synapse-s3-storage-provider";
    license = licenses.asl20;
    maintainers = with maintainers; [ yuka ];
  };
}
