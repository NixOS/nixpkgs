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
}:

buildGoModule rec {
  pname = "opensnitch";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "opensnitch";
    rev = "v${version}";
    sha256 = "1c2v2x8hfqk524sa42vry74lda4lg6ii40ljk2qx9j2f69446sva";
  };

  patches = [
    # https://github.com/evilsocket/opensnitch/pull/384 don't require
    # a configuration file in /etc
    (fetchpatch {
      name = "dont-require-config-in-etc.patch";
      url = "https://github.com/evilsocket/opensnitch/commit/8a3f63f36aa92658217bbbf46d39e6d20b2c0791.patch";
      sha256 = "sha256-WkwjKTQZppR0nqvRO4xiQoKZ307NvuUwoRx+boIpuTg=";
    })
    # Upstream has inconsistent vendoring
    ./go-mod.patch
  ];

  modRoot = "daemon";

  buildInputs = [ libnetfilter_queue libnfnetlink ];

  nativeBuildInputs = [ pkg-config protobuf go-protobuf makeWrapper ];

  vendorSha256 = "sha256-sTfRfsvyiFk1bcga009W6jD6RllrySRAU6B/8mF6+ow=";

  preBuild = ''
    make -C ../proto ../daemon/ui/protocol/ui.pb.go
  '';

  postBuild = ''
    mv $GOPATH/bin/daemon $GOPATH/bin/opensnitchd
    mkdir -p $out/lib/systemd/system
    substitute opensnitchd.service $out/lib/systemd/system/opensnitchd.service \
      --replace "/usr/local/bin/opensnitchd" "$out/bin/opensnitchd" \
      --replace "/etc/opensnitchd/rules" "/var/lib/opensnitch/rules" \
      --replace "/bin/mkdir" "${coreutils}/bin/mkdir"
  '';

  postInstall = ''
    wrapProgram $out/bin/opensnitchd \
      --prefix PATH : ${lib.makeBinPath [ iptables ]}
  '';

  meta = with lib; {
    description = "An application firewall";
    homepage = "https://github.com/evilsocket/opensnitch/wiki";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.raboof ];
    platforms = platforms.linux;
  };
}
