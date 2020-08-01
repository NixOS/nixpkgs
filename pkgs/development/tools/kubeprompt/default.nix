{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeprompt";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "jlesquembre";
    repo = pname;
    rev = version;
    sha256 = "1a0xi31bd7n2zrx2z4srhvixlbj028h63dlrjzqxgmgn2w6akbz2";
  };

  preBuild = ''
    export buildFlagsArray+=(
      "-ldflags=
        -w -s
        -X ${goPackagePath}/pkg/version.Version=${version}")
  '';

  goPackagePath = "github.com/jlesquembre/kubeprompt";
  vendorSha256 = "089lfkvyf00f05kkmr935jbrddf2c0v7m2356whqnz7ad6a2whsi";

  meta = with stdenv.lib; {
    description = "Kubernetes prompt";
    homepage = "https://github.com/jlesquembre/kubeprompt";
    license = licenses.epl20;
    maintainers = with maintainers; [ jlesquembre ];
    platforms = platforms.all;
  };
}
