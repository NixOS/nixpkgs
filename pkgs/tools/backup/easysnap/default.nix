{stdenv, fetchFromGitHub, zfs }:

stdenv.mkDerivation rec {
  name = "easysnap-${version}";
  version = "unstable-2018-10-28";

  src = fetchFromGitHub {
    owner = "sjau";
    repo = "easysnap";
    rev = "aa2768762da7730aa3eb90fdc2190a8359976edc";
    sha256 = "0csn7capsmlkin4cf1fgl766gvszvqfllqkiyz0g9bvbapxv7nba";
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
