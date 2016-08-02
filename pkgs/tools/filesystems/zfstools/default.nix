{ stdenv, fetchFromGitHub, ruby, zfs }:

let version = "0.3.3"; in
stdenv.mkDerivation rec {
  name = "zfstools-${version}";

  src = fetchFromGitHub {
    sha256 = "1gj6jksc9crmjvhsx8yp3l06b5vcm415l0bmdjcil7jjbfhwwp2k";
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

  meta = with stdenv.lib; {
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
