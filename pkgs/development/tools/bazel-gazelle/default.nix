{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "bazel-gazelle";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WmDtMOEs7cOb/juWTHjkc8/92f2OL0vurMMM15IE3YI=";
  };

  vendorHash = null;

  doCheck = false;

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
    mainProgram = "gazelle";
  };
}
