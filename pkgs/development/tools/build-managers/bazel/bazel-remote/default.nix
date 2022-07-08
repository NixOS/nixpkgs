{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "bazel-remote";
  version = "2.3.8";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iMVBkmZmjk4w5WN1sPBJQWC5Ktbl3Y6g62IpyGuM0Xg=";
  };

  vendorSha256 = "sha256-wXgW7HigMIeUZAcZpm5TH9thfCHmpz+M42toWHgwIYo=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/buchgr/bazel-remote";
    description = "A remote HTTP/1.1 cache for Bazel";
    license = licenses.asl20;
    maintainers = lib.teams.bazel.members;
    platforms = platforms.darwin ++ platforms.linux;
  };
}
