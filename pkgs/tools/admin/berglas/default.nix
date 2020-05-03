{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "berglas";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y393g36h35zzqyf5b10j6qq2jhvz83j17cmasnv6wbyrb3vnn0n";
  };

  modSha256 = "0m2bqx102lf6nihdjbl8a08xcwi80rawvh91j1cav0njm9w5vmmm";

  meta = with stdenv.lib; {
    description = "A tool for managing secrets on Google Cloud";
    homepage = "https://github.com/GoogleCloudPlatform/berglas";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
