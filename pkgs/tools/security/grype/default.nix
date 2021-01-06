{ buildGoModule
, docker
, fetchFromGitHub
, stdenv
}:

buildGoModule rec {
  pname = "grype";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "anchore";
    repo = pname;
    rev = "v${version}";
    sha256 = "0schq11vckvdj538mnkdzhxl452nrssqrfapab9qc44yxdi1wf8k";
  };

  vendorSha256 = "0lna7zhsj3wnw83nv0dp93aj869pplb51gqzrkka7vnqp0rjcw50";

  propagatedBuildInputs = [ docker ];

  # tests require a running Docker instance
  doCheck = false;

  meta = with stdenv.lib; {
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
