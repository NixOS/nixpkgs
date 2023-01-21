{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gettext
, libxslt
, docbook_xsl_ns
, libcap
, libidn2
, iproute2
, apparmorRulesFromClosure
}:

stdenv.mkDerivation rec {
  pname = "iputils";
  version = "20221126";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-XVoQhdjBmEK8TbCpaKLjebPw7ZT8iEvyLJDTCkzezeE=";
  };

  outputs = [ "out" "apparmor" ];

  # We don't have the required permissions inside the build sandbox:
  # /build/source/build/ping/ping: socket: Operation not permitted
  doCheck = false;

  mesonFlags = [
    "-DNO_SETCAP_OR_SUID=true"
    "-Dsystemdunitdir=etc/systemd/system"
    "-DINSTALL_SYSTEMD_UNITS=true"
    "-DSKIP_TESTS=${lib.boolToString (!doCheck)}"
  ]
  # Disable idn usage w/musl (https://github.com/iputils/iputils/pull/111):
  ++ lib.optional stdenv.hostPlatform.isMusl "-DUSE_IDN=false";

  nativeBuildInputs = [ meson ninja pkg-config gettext libxslt.bin docbook_xsl_ns ];
  buildInputs = [ libcap ]
    ++ lib.optional (!stdenv.hostPlatform.isMusl) libidn2;
  checkInputs = [ iproute2 ];

  postInstall = ''
    mkdir $apparmor
    cat >$apparmor/bin.ping <<EOF
    include <tunables/global>
    $out/bin/ping {
      include <abstractions/base>
      include <abstractions/consoles>
      include <abstractions/nameservice>
      include "${apparmorRulesFromClosure { name = "ping"; }
       ([libcap] ++ lib.optional (!stdenv.hostPlatform.isMusl) libidn2)}"
      include <local/bin.ping>
      capability net_raw,
      network inet raw,
      network inet6 raw,
      mr $out/bin/ping,
      r $out/share/locale/**,
      r @{PROC}/@{pid}/environ,
    }
    EOF
  '';

  meta = with lib; {
    homepage = "https://github.com/iputils/iputils";
    changelog = "https://github.com/iputils/iputils/releases/tag/${version}";
    description = "A set of small useful utilities for Linux networking";
    longDescription = ''
      A set of small useful utilities for Linux networking including:

      - arping: send ARP REQUEST to a neighbour host
      - clockdiff: measure clock difference between hosts
      - ping: send ICMP ECHO_REQUEST to network hosts
      - tracepath: traces path to a network host discovering MTU along this path
    '';
    license = with licenses; [ gpl2Plus bsd3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos lheckemann ];
  };
}
