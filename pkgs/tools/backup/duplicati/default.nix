{ stdenv, fetchzip, mono, sqlite, makeWrapper }:

stdenv.mkDerivation rec {
  name = "duplicati-${version}";
  version = "2.0.3.3";
  channel = "beta";
  build_date = "2018-04-02";

  src = fetchzip {
    url = "https://github.com/duplicati/duplicati/releases/download/v${version}-${version}_${channel}_${build_date}/duplicati-${version}_${channel}_${build_date}.zip";
    sha256 = "0hwdpsgrvm3gq648mg9g0z0rk49g71dd8r5i1a8w83pwdqv0hn9c";
    stripRoot = false;
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share/${name}}
    cp -r * $out/share/${name}
    makeWrapper "${mono}/bin/mono" $out/bin/duplicati-cli \
      --add-flags "$out/share/${name}/Duplicati.CommandLine.exe" \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [
          sqlite ]}
    makeWrapper "${mono}/bin/mono" $out/bin/duplicati-server \
      --add-flags "$out/share/${name}/Duplicati.Server.exe" \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [
          sqlite ]}
  '';

  meta = with stdenv.lib; {
    description = "A free backup client that securely stores encrypted, incremental, compressed backups on cloud storage services and remote file servers";
    homepage = https://www.duplicati.com/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ nyanloutre ];
    platforms = platforms.all;
  };
}
