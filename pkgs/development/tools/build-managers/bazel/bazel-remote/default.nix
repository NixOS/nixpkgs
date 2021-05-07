{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "bazel-remote";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = pname;
    rev = "v${version}";
    sha256 = "193amcx4nk7mr51jcawym46gizqmfkvksjxm64pf7s3wraf00v01";
  };

  vendorSha256 = "1sxv9mya8plkn3hpjgfpzgwlh4m3cbhpywqv86brj2h9i4ad0gl5";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/buchgr/bazel-remote";
    description = "A remote HTTP/1.1 cache for Bazel";
    license = licenses.asl20;
    maintainers = [ maintainers.uri-canva ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
