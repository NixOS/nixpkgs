{ lib, stdenv, fetchFromGitHub, ruby, zfs }:

stdenv.mkDerivation rec {
  pname = "zfstools";
  version = "0.3.6";

  src = fetchFromGitHub {
    sha256 = "16lvw3xbmxp2pr8nixqn7lf4504zaaxvbbdnjkv4dggwd4lsdjyg";
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

  meta = with lib; {
    inherit version;
    inherit (src.meta) homepage;
    description = "OpenSolaris-compatible auto-snapshotting script for ZFS";
    longDescription = ''
      zfstools is an OpenSolaris-like and compatible auto snapshotting script
      for ZFS, which also supports auto snapshotting mysql databases.
    '';
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
