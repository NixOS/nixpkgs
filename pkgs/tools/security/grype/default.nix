{ buildGoModule
, docker
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "grype";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "anchore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-co00Ye/QVNSG4h67m56+37JLilBVzHxUwMs1vS3wYX4=";
  };

  vendorSha256 = "sha256-q7n8WLw/A2wr3z5h7zaFERY7lO5UIsmTD2mrcH/vpNs=";

  propagatedBuildInputs = [ docker ];

  # tests require a running Docker instance
  doCheck = false;

  meta = with lib; {
    description = "Vulnerability scanner for container images and filesystems";
    longDescription = ''
      As a vulnerability scanner is grype abale to scan the contents of a container
      image or filesystem to find known vulnerabilities.
    '';
    homepage = "https://github.com/anchore/grype";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
