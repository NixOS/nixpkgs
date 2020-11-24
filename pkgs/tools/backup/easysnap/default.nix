{stdenv, fetchFromGitHub, zfs }:

stdenv.mkDerivation {
  pname = "easysnap";
  version = "unstable-2020-05-12";

  src = fetchFromGitHub {
    owner = "sjau";
    repo = "easysnap";
    rev = "3ac75c6e2a6f42c9aa4d561184a324ba61633fef";
    sha256 = "1k7adqly3rja39mk2dwz1g4j3q0lig5lxawj6hadcc9qgha2yqsm";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -n easysnap* $out/bin/

    for i in $out/bin/*; do
      substituteInPlace $i \
        --replace zfs ${zfs}/bin/zfs
    done
  '';

  meta = with stdenv.lib; {
    homepage    = "https://github.com/sjau/easysnap";
    description = "Customizable ZFS Snapshotting tool with zfs send/recv pulling";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ sjau ];
  };

}
