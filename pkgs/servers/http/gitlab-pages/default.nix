{ buildGoModule, lib, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-pages";
  version = "1.21.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-pages";
    rev = "v${version}";
    sha256 = "0f317lx4iarlsbnq2ipcm4lpx66xzl8wfilj8xajq1csz19ws24z";
  };

  vendorSha256 = "186rxvl523n1d87jz4zzbj83ikzw9d0c1wrj78xs4iqzm8z3snh0";
  subPackages = [ "." ];
  doCheck = false; # Broken

  meta = with lib; {
    description = "Daemon used to serve static websites for GitLab users";
    homepage = "https://gitlab.com/gitlab-org/gitlab-pages";
    license = licenses.mit;
    maintainers = with maintainers; [ das_j ];
  };
}
