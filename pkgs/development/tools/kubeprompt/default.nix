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
  modSha256 = "0rbpdk2dixywn3wcdgz48f3xw3b7fk8xh7mrlx27wz7fq5wj9v8f";

  meta = with stdenv.lib; {
    description = "Kubernetes prompt";
    homepage = "https://github.com/jlesquembre/kubeprompt";
    license = licenses.epl20;
    maintainers = with maintainers; [ jlesquembre ];
    platforms = platforms.all;
  };
}
