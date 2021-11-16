{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "bazel-gazelle";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WWAOhV1H/OnARjhoWQYNmd9/y8pD3bRkhncmzt/36mA=";
  };

  vendorSha256 = null;

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
  };
}
