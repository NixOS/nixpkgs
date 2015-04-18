{ stdenv, fetchFromGitHub, ruby, zfs }:

stdenv.mkDerivation rec {
  name = "zfstools-${version}";

  version = "0.3.2";

  src = fetchFromGitHub {
    sha256 = "1dzfir9413qrmx9kqpndi3l2m09f6l1wspnwn84lm3n1g9cr46nd";
    rev = "v${version}";
    repo = "zfstools";
    owner = "bdrewery";
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
    inherit version;
    homepage = https://github.com/bdrewery/zfstools;
    description = "OpenSolaris-like and compatible auto snapshotting script for ZFS";
    longDescription = ''
      zfstools is an OpenSolaris-like and compatible auto snapshotting script
      for ZFS, which also supports auto snapshotting mysql databases.
    '';

    license = stdenv.lib.licenses.bsd2;
  };
}
