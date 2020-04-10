{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "docker-credential-gcr";
  version = "2.0.1";

  goPackagePath = "github.com/GoogleCloudPlatform/docker-credential-gcr";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "docker-credential-gcr";
    rev = "v${version}";
    sha256 = "0zazbfjbwclkz848vsyb6zhn95gngwrdhivaiw0m9f8a9xm4bp9r";
  };

  meta = with stdenv.lib; {
    description = "A Docker credential helper for GCR (https://gcr.io) users";
    longDescription = ''
      docker-credential-gcr is Google Container Registry's Docker credential
      helper. It allows for Docker clients v1.11+ to easily make
      authenticated requests to GCR's repositories (gcr.io, eu.gcr.io, etc.).
    '';
    homepage = "https://github.com/GoogleCloudPlatform/docker-credential-gcr";
    license = licenses.asl20;
    maintainers = with maintainers; [ suvash ];
  };
}
