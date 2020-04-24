{stdenv, fetchFromGitHub, zfs }:

stdenv.mkDerivation {
  pname = "easysnap";
  version = "unstable-2020-04-24";

  src = fetchFromGitHub {
    owner = "sjau";
    repo = "easysnap";
    rev = "95cfd1fdda5bc8c111eee171289d29b9f66081cd";
    sha256 = "1hchqqj0k54f1174fvb6c6r19lrfq0ldfasm05qh6mbfjm6x390v";
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
