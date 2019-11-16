{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gitlab-ci-pipelines-exporter";
  version = "0.2.5";

  goPackagePath = "github.com/mvisonneau/gitlab-ci-pipelines-exporter";

  goDeps = ./gitlab-ci-pipelines-exporter_deps.nix;

  src = fetchFromGitHub {
    owner = "mvisonneau";
    repo = pname;
    rev = version;
    sha256 = "0qmy6pqfhx9bphgh1zqi68kp0nscwy1x7z13lfiaaz8pgsjh95yy";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Prometheus / OpenMetrics exporter for GitLab CI pipelines insights";
    homepage = "https://github.com/mvisonneau/gitlab-ci-pipelines-exporter";
    license = licenses.asl20;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.all;
  };
}
