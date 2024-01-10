{ buildGoModule
, fetchFromGitHub
, lib
}:
buildGoModule rec {
  pname = "protoc-gen-go-vtproto";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "vtprotobuf";
    rev = "v${version}";
    sha256 = "sha256-2DpL8CYl0MWpr7TBJPwDlgKvOoa5RrVwMjOxrEP5Wio=";
  };

  vendorHash = "sha256-JpSVO8h7+StLG9/dJQkmrIlh9zIHABoqP1hq+X5ajVs=";

  excludedPackages = [ "conformance" ];

  meta = with lib; {
    description = "A Protocol Buffers compiler that generates optimized marshaling & unmarshaling Go code for ProtoBuf APIv2";
    homepage = "https://github.com/planetscale/vtprotobuf";
    license = licenses.bsd3;
    maintainers = [ maintainers.zane ];
  };
}
