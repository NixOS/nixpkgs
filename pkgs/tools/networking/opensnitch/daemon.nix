{ buildGoModule
, fetchFromGitHub
, fetchpatch
, protobuf
, go-protobuf
, pkg-config
, libnetfilter_queue
, libnfnetlink
, lib
, coreutils
, iptables
, makeWrapper
, protoc-gen-go-grpc
, testers
, opensnitch
}:

buildGoModule rec {
  pname = "opensnitch";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "opensnitch";
    rev = "v${version}";
    sha256 = "sha256-MF7K3WasG1xLdw1kWz6xVYrdfuZW5GUq6dlS0pPOkHI=";
  };

  patches = [
    # https://github.com/evilsocket/opensnitch/pull/384 don't require
    # a configuration file in /etc
    (fetchpatch {
      name = "dont-require-config-in-etc.patch";
      url = "https://github.com/evilsocket/opensnitch/commit/8a3f63f36aa92658217bbbf46d39e6d20b2c0791.patch";
      sha256 = "sha256-WkwjKTQZppR0nqvRO4xiQoKZ307NvuUwoRx+boIpuTg=";
    })
  ];

  modRoot = "daemon";

  buildInputs = [ libnetfilter_queue libnfnetlink ];

  nativeBuildInputs = [ pkg-config protobuf go-protobuf makeWrapper protoc-gen-go-grpc ];

  vendorSha256 = "sha256-jWP0oF+jZRFMi5Y2y0SARMoP8wTKVZ8UWra9JNzdSOw=";

  preBuild = ''
    # Fix inconsistent vendoring build error
    # https://github.com/evilsocket/opensnitch/issues/770
    cp ${./go.mod} go.mod
    cp ${./go.sum} go.sum

    make -C ../proto ../daemon/ui/protocol/ui.pb.go
  '';

  postBuild = ''
    mv $GOPATH/bin/daemon $GOPATH/bin/opensnitchd
    mkdir -p $out/etc/opensnitchd $out/lib/systemd/system
    cp system-fw.json $out/etc/opensnitchd/
    substitute default-config.json $out/etc/default-config.json \
      --replace "/var/log/opensnitchd.log" "/dev/stdout" \
      --replace "iptables" "nftables" \
      --replace "ebpf" "proc"
    substitute opensnitchd.service $out/lib/systemd/system/opensnitchd.service \
      --replace "/usr/local/bin/opensnitchd" "$out/bin/opensnitchd" \
      --replace "/etc/opensnitchd/rules" "/var/lib/opensnitch/rules" \
      --replace "/bin/mkdir" "${coreutils}/bin/mkdir"
  '';

  postInstall = ''
    wrapProgram $out/bin/opensnitchd \
      --prefix PATH : ${lib.makeBinPath [ iptables ]}
  '';

  passthru.tests.version = testers.testVersion {
    package = opensnitch;
    command = "opensnitchd -version";
  };

  meta = with lib; {
    description = "An application firewall";
    homepage = "https://github.com/evilsocket/opensnitch/wiki";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}
