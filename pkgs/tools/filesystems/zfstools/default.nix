{ stdenv, fetchgit, ruby, zfs }:

stdenv.mkDerivation rec {
  name = "zfstools-${version}";

  version = "0.3.1";

  src = fetchgit {
    url = https://github.com/bdrewery/zfstools.git;
    rev = "refs/tags/v${version}";
    sha256 = "0bhs0gn1f4z1jm631vp26sbysy4crq489q56rxqfd8ns1xsp1f5j";
  };

  buildInputs = [ ruby ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin/

    cp -R lib $out/

    for f in $out/bin/*; do
      substituteInPlace $f --replace "/usr/bin/env ruby" "ruby -I$out/lib"
    done

    sed -e 's|cmd.*=.*"zfs |cmd = "${zfs}/sbin/zfs |g' -i $out/lib/zfstools/{dataset,snapshot}.rb
  '';

  meta = {
    homepage = https://github.com/bdrewery/zfstools;
    description = "OpenSolaris-like and compatible auto snapshotting script for ZFS";
    longDescription = ''
      zfstools is an OpenSolaris-like and compatible auto snapshotting script
      for ZFS, which also supports auto snapshotting mysql databases.
    '';

    license = stdenv.lib.licenses.bsd2;
  };
}
