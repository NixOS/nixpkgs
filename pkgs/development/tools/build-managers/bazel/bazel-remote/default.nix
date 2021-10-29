{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "bazel-remote";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zRZlpZWGZpBHc5DtqxeVc4xmJDKTem54/Fx/41i57c4=";
  };

  vendorSha256 = "sha256-N0UfC/M6EBbnpBpOTNkGgFEJpTA3VQ2jg9M7kxQQQc8=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/buchgr/bazel-remote";
    description = "A remote HTTP/1.1 cache for Bazel";
    license = licenses.asl20;
    maintainers = [ maintainers.uri-canva ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
