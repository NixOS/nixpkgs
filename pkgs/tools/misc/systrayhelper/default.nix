{ stdenv, pkgconfig, libappindicator-gtk3, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "systrayhelper-${version}";
  version = "0.0.3";
  rev = "0953942245566bf358ba937af840947100380e15";

  goPackagePath = "github.com/ssbc/systrayhelper";

  src = fetchFromGitHub {
    inherit rev;
    owner = "ssbc";
    repo = "systrayhelper";
    sha256 = "12xmzcw94in4m1hl4hbfdsbvkkaqrljgb67b95m1qwkkjak3q9g6";
  };

  goDeps = ./deps.nix;

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
