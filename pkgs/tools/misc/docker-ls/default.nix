{ buildGoPackage, fetchFromGitHub, stdenv, docker }:

buildGoPackage rec {
  name = "docker-ls-${version}";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "mayflower";
    repo = "docker-ls";
    rev = "v${version}";
    sha256 = "1hb9b0jhaf01zlmkm353mz608kwb79dzic3gvb2fhyrh8d17w2iv";
  };

  goPackagePath = "github.com/mayflower/docker-ls";

  meta = with stdenv.lib; {
    description = "Tools for browsing and manipulating docker registries";
    longDescription = ''
      Docker-ls is a set of CLI tools for browsing and manipulating docker registries.
      In particular, docker-ls can handle authentication and display the sha256 content digests associated
      with tags.
    '';

    homepage = https://github.com/mayflower/docker-ls;
    maintainers = with maintainers; [ ma27 ];
    platforms = docker.meta.platforms;
    license = licenses.mit;
  };
}
