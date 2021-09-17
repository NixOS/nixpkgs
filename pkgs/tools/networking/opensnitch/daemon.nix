{ buildGoModule
, fetchFromGitHub
, fetchpatch
, pkg-config
, libnetfilter_queue
, libnfnetlink
, lib
, coreutils
, iptables
}:

buildGoModule rec {
  pname = "opensnitch";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "opensnitch";
    rev = "v${version}";
    sha256 = "sha256-Cgo+bVQQeUZuYYhA1WSqlLyQQGAeXbbNno9LS7oNvhI=";
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

  postBuild = ''
    mv $GOPATH/bin/daemon $GOPATH/bin/opensnitchd
    mkdir -p $out/lib/systemd/system
    substitute opensnitchd.service $out/lib/systemd/system/opensnitchd.service \
      --replace "/usr/local/bin/opensnitchd" "$out/bin/opensnitchd" \
      --replace "/etc/opensnitchd/rules" "/var/lib/opensnitch/rules" \
      --replace "/bin/mkdir" "${coreutils}/bin/mkdir"
    sed -i '/\[Service\]/a Environment=PATH=${iptables}/bin' $out/lib/systemd/system/opensnitchd.service
  '';

  vendorSha256 = "sha256-LMwQBFkHg1sWIUITLOX2FZi5QUfOivvrkcl9ELO3Trk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libnetfilter_queue libnfnetlink ];

  meta = with lib; {
    description = "An application firewall";
    homepage = "https://github.com/evilsocket/opensnitch/wiki";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.raboof ];
    platforms = platforms.linux;
  };
}
