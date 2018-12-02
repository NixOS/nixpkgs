{ stdenv, pkgconfig, libappindicator-gtk3, buildGoPackage, fetchFromGitHub
# for tests
, dbus
, i3
, xdotool
, xvfb_run
}:

buildGoPackage rec {
  name = "systrayhelper-${version}";
  version = "0.0.5";
  rev = "48c47f89b1bae8f3a09d449a96f8df2bf0776560";

  goPackagePath = "github.com/ssbc/systrayhelper";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "ssbc";
    repo = "systrayhelper";
    sha256 = "0bn3nf43m89qmh8ds5vmv0phgdz32idz1zisr47jmvqm2ky1a45s";
  };

  # re date: https://github.com/NixOS/nixpkgs/pull/45997#issuecomment-418186178
  # > .. keep the derivation deterministic. Otherwise, we would have to rebuild it every time.
  buildFlagsArray = [ ''-ldflags=
    -X main.version=v${version}
    -X main.commit=${rev}
    -X main.date="nix-byrev"
    -s
    -w
  '' ];

  nativeBuildInputs = [ pkgconfig libappindicator-gtk3 ];
  buildInputs = [ libappindicator-gtk3 ];

  enableParallelBuilding = true;

  checkInputs = [ xvfb_run dbus i3 xdotool ];
  doCheck = stdenv.isLinux;
  # use the override.nix from the source to extract and watch tests
  checkPhase = ''
    export TRAY_I3=true
    xvfb-run -s '-screen 0 800x600x16' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      go test -timeout 1m -v github.com/ssbc/systrayhelper/test
  '';

  meta = with stdenv.lib; {
    description = "A systray utility written in go, using json over stdio for control and events";
    homepage    = "https://github.com/ssbc/systrayhelper";
    maintainers = with maintainers; [ cryptix ];
    license     = licenses.mit;
    # It depends on the inputs, i guess? not sure about solaris, for instance. go supports it though
    # I hope nix can figure this out?! ¯\\_(ツ)_/¯
    platforms   = platforms.all;
  };
}
