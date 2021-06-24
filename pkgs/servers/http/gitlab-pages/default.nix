{ buildGoModule, lib, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "1.35.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    sha256 = "sha256-5AkzbOutBXy59XvMwfyH6A8ETwjP2QokG/Rz31/nCpk=";
  };

  vendorSha256 = "sha256-g8FDWpZmbZSkJAzoEiI8/JZLTTgG7uJ4sS35axaEXLY=";
  subPackages = [ "." ];
  doCheck = false; # Broken

  meta = with lib; {
    description = "Daemon used to serve static websites for GitLab users";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    license = licenses.mit;
    maintainers = with maintainers; [ das_j ];
  };
}
