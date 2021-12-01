{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, gettext, libxslt, docbook_xsl_ns
, libcap, libidn2
, iproute2
, apparmorRulesFromClosure
}:

let
  version = "20210722";
  sunAsIsLicense = {
    fullName = "AS-IS, SUN MICROSYSTEMS license";
    url = "https://github.com/iputils/iputils/blob/s${version}/rdisc.c";
  };
in stdenv.mkDerivation rec {
  pname = "iputils";
  inherit version;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "139fyifsjm0i012rhcx3ra3pxx2wxh77dfd551d8lgiv2mqd742j";
  };

  postPatch = lib.optionalString (!doCheck) ''
    # There isn't a Meson option for this yet:
    sed -i '/##### TESTS #####/q' ping/meson.build
  '';

  outputs = ["out" "apparmor"];

  # We don't have the required permissions inside the build sandbox:
  # /build/source/build/ping/ping: socket: Operation not permitted
  doCheck = false;

  mesonFlags = [
    "-DBUILD_RARPD=true"
    "-DBUILD_TRACEROUTE6=true"
    "-DBUILD_TFTPD=true"
    "-DNO_SETCAP_OR_SUID=true"
    "-Dsystemdunitdir=etc/systemd/system"
    "-DINSTALL_SYSTEMD_UNITS=true"
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
    description = "A set of small useful utilities for Linux networking";
    inherit (src.meta) homepage;
    changelog = "https://github.com/iputils/iputils/releases/tag/s${version}";
    license = with licenses; [ gpl2Plus bsd3 sunAsIsLicense ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos lheckemann ];

    longDescription = ''
      A set of small useful utilities for Linux networking including:

      arping
      clockdiff
      ninfod
      ping
      rarpd
      rdisc
      tftpd
      tracepath
      traceroute6
    '';
  };
}
