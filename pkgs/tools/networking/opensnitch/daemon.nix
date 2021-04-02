{ buildGoModule
, fetchFromGitHub
, fetchpatch
, protobuf
, go-protobuf
, pkg-config
, libnetfilter_queue
, libnfnetlink
, lib
}:

buildGoModule rec {
  pname = "opensnitch";
  version = "1.4.0-rc.2";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "opensnitch";
    rev = "v${version}";
    sha256 = "1kj32lc5pksh0r2j4x8ihasch1is8ahxhmd8q49dydm9z64f3nya";
  };

  patches = [
    # https://github.com/evilsocket/opensnitch/pull/417
    (fetchpatch {
      name = "add-gpbpf-to-go.mod";
      url = "https://github.com/evilsocket/opensnitch/commit/356428b6c9f05447ed3c3ea19b5f507d16fba80a.patch";
      sha256 = "sha256:0fc9qyj68rmdij2biq01bs7ky0k6hl21pk48gipk6w5l3cg2d085";
    })
    (fetchpatch {
      name = "dont-require-config-in-etc.patch";
      url = "https://github.com/evilsocket/opensnitch/commit/8a3f63f36aa92658217bbbf46d39e6d20b2c0791.patch";
      sha256 = "sha256:0f5r5616wzhwl4qfbgnd9vgrk0j2ca63pldbkrs999hr6hlj6k2s";
    })
  ];

  modRoot = "daemon";

  vendorSha256 = "sha256:13rwmk9asyz92937y7ggmisrmnzwvw6gylb2v5sigfsd5k0mqjxv";

  nativeBuildInputs = [ pkg-config protobuf go-protobuf ];

  preBuild = ''
    make -C ../proto ../daemon/ui/protocol/ui.pb.go
  '';

  buildInputs = [ libnetfilter_queue libnfnetlink ];

  postBuild = ''
    mv $GOPATH/bin/daemon $GOPATH/bin/opensnitchd
  '';


  meta = with lib; {
    description = "An application firewall";
    homepage = "https://github.com/evilsocket/opensnitch/wiki";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.raboof ];
    platforms = platforms.linux;
  };
}
