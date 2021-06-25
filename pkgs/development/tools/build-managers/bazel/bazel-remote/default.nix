{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "bazel-remote";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GpbweI/grJNIRg/7lFd4tMhr9E2SPX+YUrzPJs0Gsik=";
  };

  vendorSha256 = "sha256-dXBGWTgUaVJCwf2LB1QdmSPP3BlKqZ28HUnq1oervNg=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/buchgr/bazel-remote";
    description = "A remote HTTP/1.1 cache for Bazel";
    license = licenses.asl20;
    maintainers = [ maintainers.uri-canva ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
