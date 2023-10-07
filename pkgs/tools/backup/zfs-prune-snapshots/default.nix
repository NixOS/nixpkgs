{ lib, stdenv, fetchFromGitHub, go-md2man }:

stdenv.mkDerivation rec {
  version = "1.5.0";
  pname = "zfs-prune-snapshots";

  src = fetchFromGitHub {
    owner = "bahamas10";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gCf/ZIeIh84WQNs5wZO1/l3zpnl2sNxsFO7cOa92JUM=";
  };

  nativeBuildInputs = [ go-md2man ];

  makeTargets = [ "man" ];

  installPhase = ''
    install -m 755 -D zfs-prune-snapshots $out/bin/zfs-prune-snapshots
    install -m 644 -D man/zfs-prune-snapshots.1 $out/share/man/man1/zfs-prune-snapshots.1
  '';

  meta = with lib; {
    description = "Remove snapshots from one or more zpools that match given criteria";
    homepage = "https://github.com/bahamas10/zfs-prune-snapshots";
    license = licenses.mit;
    maintainers = [ maintainers.ymarkus ];
    platforms = platforms.all;
  };
}
