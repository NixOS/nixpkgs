{ buildGoModule, lib, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "1.28.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    sha256 = "15q32blkhmc5w1b2xh45y7cag8f6bw9bgiwin5ykrzj5d305wd16";
  };

  vendorSha256 = "1gzkb2j2hl6ln8i5wjk2n9g8agpdzy1pzghb4sy1r8pdfp0i28r3";
  subPackages = [ "." ];
  doCheck = false; # Broken

  meta = with lib; {
    description = "Daemon used to serve static websites for GitLab users";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    license = licenses.mit;
    maintainers = with maintainers; [ das_j ];
  };
}
