{ buildGoModule, lib, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "1.34.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    sha256 = "sha256-bJ9BQbAe35z5cIw0HhFjM6arWf1Tdy4gRipAHywxZZk=";
  };

  vendorSha256 = "sha256-amPL0gzvqsacj7+UNJeZOQbeiBESUttbtPHxLpDykRI=";
  subPackages = [ "." ];
  doCheck = false; # Broken

  meta = with lib; {
    description = "Daemon used to serve static websites for GitLab users";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    license = licenses.mit;
    maintainers = with maintainers; [ das_j ];
  };
}
