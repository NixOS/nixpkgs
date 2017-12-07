{ buildGoPackage, fetchFromGitHub, stdenv, docker }:

buildGoPackage rec {
  name = "docker-ls-${version}";
  version = "v0.3.1";

  src = fetchFromGitHub {
    owner = "mayflower";
    repo = "docker-ls";
    rev = version;
    sha256 = "1dhadi1s3nm3r8q5a0m59fy4jdya8p7zvm22ci7ifm3mmw960xly";
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
