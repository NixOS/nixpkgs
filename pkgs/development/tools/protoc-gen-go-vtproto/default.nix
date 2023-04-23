{ buildGoModule
, fetchFromGitHub
, lib
}:
buildGoModule rec {
  pname = "protoc-gen-go-vtproto";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "vtprotobuf";
    rev = "v${version}";
    sha256 = "sha256-WtiXoQWjjFf+TP2zpAXNH05XdcrLSpw3S0TG4lkzp2E=";
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
