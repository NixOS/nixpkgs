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
, nixosTests
}:

buildGoModule rec {
  pname = "opensnitch";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "opensnitch";
    rev = "v${version}";
    hash = "sha256-C8Uuz2FC7Zu07ZmFpp+ejpNxkyC3/mM9J2dc5FUKx64=";
  };

  postPatch = ''
    # Allow configuring Version at build time
    substituteInPlace daemon/core/version.go --replace "const " "var "
  '';

  modRoot = "daemon";

  buildInputs = [
    libnetfilter_queue
    libnfnetlink
  ];

  nativeBuildInputs = [
    pkg-config
    protobuf
    go-protobuf
    makeWrapper
    protoc-gen-go-grpc
  ];

  vendorHash = "sha256-bUzGWpQxeXzvkzQ7G53ljQJq6wwqiXqbi6bgeFlNvvM=";

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
    substitute default-config.json $out/etc/opensnitchd/default-config.json \
      --replace "/var/log/opensnitchd.log" "/dev/stdout"
    substitute opensnitchd.service $out/lib/systemd/system/opensnitchd.service \
      --replace "/usr/local/bin/opensnitchd" "$out/bin/opensnitchd" \
      --replace "/etc/opensnitchd/rules" "/var/lib/opensnitch/rules" \
      --replace "/bin/mkdir" "${coreutils}/bin/mkdir"
  '';

  ldflags = [ "-s" "-w" "-X github.com/evilsocket/opensnitch/daemon/core.Version=${version}" ];

  postInstall = ''
    wrapProgram $out/bin/opensnitchd \
      --prefix PATH : ${lib.makeBinPath [ iptables ]}
  '';

  passthru.tests = {
    inherit (nixosTests) opensnitch;
    version = testers.testVersion {
      package = opensnitch;
      command = "opensnitchd -version";
    };
  };

  meta = with lib; {
    description = "An application firewall";
    homepage = "https://github.com/evilsocket/opensnitch/wiki";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}
