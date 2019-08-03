{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "docker-credential-gcr-${version}";
  version = "1.4.3";

  goPackagePath = "github.com/GoogleCloudPlatform/docker-credential-gcr";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "docker-credential-gcr";
    rev = "v${version}";
    sha256 = "1xb88xjyyrdmjcgfv7fqdkv1ip3dpzsdif5vm7vkqvn83s5wj5df";
  };

  meta = with stdenv.lib; {
    description = "A Docker credential helper for GCR (https://gcr.io) users";
    longDescription = ''
      docker-credential-gcr is Google Container Registry's Docker credential
      helper. It allows for Docker clients v1.11+ to easily make
      authenticated requests to GCR's repositories (gcr.io, eu.gcr.io, etc.).
    '';
    homepage = https://github.com/GoogleCloudPlatform/docker-credential-gcr;
    license = licenses.asl20;
    maintainers = with maintainers; [ suvash ];
  };
}
