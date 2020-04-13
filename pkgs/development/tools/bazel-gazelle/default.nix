{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "bazel-gazelle";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rw9zq8rmc0zr91kk70xl67dl6jx4dswwisv3bd1f16yncqgv2a1";
  };

  modSha256 = "0bfhy0ig8apxb5qzxjdj6q7jr2i6rdq0ffby0pha8viadah8v2rm";

  subPackages = [ "cmd/gazelle" ];

  meta = with lib; {
    homepage = "https://github.com/bazelbuild/bazel-gazelle";
    description = ''
      Gazelle is a Bazel build file generator for Bazel projects. It natively
      supports Go and protobuf, and it may be extended to support new languages
      and custom rule sets.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
  };
}
