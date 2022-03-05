{ buildGoModule, lib, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "1.51.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    sha256 = "sha256-TOHD3SEKz5aVG4ikqls4sYMa+FnP8YaCoVAl+HRG9Sc=";
  };

  vendorSha256 = "sha256-0Vp+dVDMLl52dKLj1v+mgg+odu5DNfrANBzTztVymh8=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "Daemon used to serve static websites for GitLab users";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    changelog = "https://gitlab.com/gitlab-org/gitlab-pages/-/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ajs124 das_j ];
  };
}
