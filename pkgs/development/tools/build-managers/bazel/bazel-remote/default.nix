{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "bazel-remote";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tPjjYudUI+LlmdnEvHh+kUpAbmhiNPYhjf8fMglrzIM=";
  };

  vendorSha256 = "sha256-JNVzy4WbpwH9ZfO78AHQM8pak/ZVQqapxxs9QraMhDo=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/buchgr/bazel-remote";
    description = "A remote HTTP/1.1 cache for Bazel";
    license = licenses.asl20;
    maintainers = [ maintainers.uri-canva ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
