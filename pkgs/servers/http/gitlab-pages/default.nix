{ buildGoModule, lib, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "1.30.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    sha256 = "0gn5lwn1lk1ghv6lw0fvax0m829w09mmq8flbmcxvszfyv7x0rix";
  };

  vendorSha256 = "08zma4b58b9132h41m6frbdi502yima9lkpab87fi0q5r6qwhf1z";
  subPackages = [ "." ];
  doCheck = false; # Broken

  meta = with lib; {
    description = "Daemon used to serve static websites for GitLab users";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    license = licenses.mit;
    maintainers = with maintainers; [ das_j ];
  };
}
