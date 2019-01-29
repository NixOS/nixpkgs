{stdenv, fetchFromGitHub, zfs }:

stdenv.mkDerivation rec {
  name = "easysnap-${version}";
  version = "unstable-2018-11-20";

  src = fetchFromGitHub {
    owner = "sjau";
    repo = "easysnap";
    rev = "dbf58c06a339cb040dbdcaf7e6ffec5af4add3c7";
    sha256 = "0rvikmj2k103ffgnvkway8n6ajq0vzwcxb4l5vhka1hqh8047lam";
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
