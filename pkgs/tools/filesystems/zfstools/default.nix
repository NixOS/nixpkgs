{ lib, stdenv, fetchFromGitHub, ruby, zfs, makeWrapper }:

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
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin/

    cp -R lib $out/

    for f in $out/bin/*; do
      wrapProgram $f \
        --set RUBYLIB $out/lib \
        --prefix PATH : ${zfs}/bin
    done
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
