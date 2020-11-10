{stdenv, fetchFromGitHub, zfs }:

stdenv.mkDerivation {
  pname = "easysnap";
  version = "unstable-2020-04-04";

  src = fetchFromGitHub {
    owner = "sjau";
    repo = "easysnap";
    rev = "26f89c0c3cda01e2595ee19ae5fb8518da25b4ef";
    sha256 = "1k49k1m7y8s099wyiiz8411i77j1156ncirynmjfyvdhmhcyp5rw";
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
