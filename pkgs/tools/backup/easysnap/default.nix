{stdenv, fetchFromGitHub, zfs }:

stdenv.mkDerivation rec {
  name = "easysnap-${version}";
  version = "unstable-2018-10-28";

  src = fetchFromGitHub {
    owner = "sjau";
    repo = "easysnap";
    rev = "0d5726828646609fc90a8e2701f779ce5f1210df";
    sha256 = "1xzqxz5111g5inx7qib7l99w9chllqfg6kkqyaxy95msza3xffb0";
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
    homepage    = https://github.com/sjau/easysnap;
    description = "Customizable ZFS Snapshotting tool with zfs send/recv pulling";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ sjau ];
  };

}
