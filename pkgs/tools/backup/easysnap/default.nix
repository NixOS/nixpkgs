{stdenv, fetchFromGitHub, zfs }:

stdenv.mkDerivation rec {
  name = "easysnap-${version}";
  version = "unstable-2019-02-17";

  src = fetchFromGitHub {
    owner = "sjau";
    repo = "easysnap";
    rev = "9ef5d1ff51ccf9939a88b7b32b4959d27cf61ecc";
    sha256 = "0m0217ni909nham15w5vxg8y7cw2zwjibnhvgnpxxsap8zkhv1m4";
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
