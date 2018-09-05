{ stdenv, pkgconfig, libappindicator-gtk3, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "systrayhelper-${version}";
  version = "0.0.2";
  rev = "9cefb226229126f5942a179ec93051d57846c48a";

  goPackagePath = "github.com/ssbc/systrayhelper";

  src = fetchFromGitHub {
    inherit rev;
    owner = "ssbc";
    repo = "systrayhelper";
    sha256 = "03wfc5ws49vdf3albzp6lw2jm2dh1g05c6lidind6ahz1nc9pqk6";
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
