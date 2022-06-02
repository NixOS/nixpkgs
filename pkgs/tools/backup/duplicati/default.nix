{ lib, stdenv, fetchzip, mono, sqlite, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "duplicati";
  version = "2.0.6.3";
  channel = "beta";
  build_date = "2021-06-17";

  src = fetchzip {
    url = "https://github.com/duplicati/duplicati/releases/download/v${version}-${version}_${channel}_${build_date}/duplicati-${version}_${channel}_${build_date}.zip";
    sha256 = "sha256-usMwlmer6rLgP46wGVkaAIocUW4MjuEpVWdX7rRcghg=";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}
    makeWrapper "${mono}/bin/mono" $out/bin/duplicati-cli \
      --add-flags "$out/share/${pname}-${version}/Duplicati.CommandLine.exe" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
          sqlite ]}
    makeWrapper "${mono}/bin/mono" $out/bin/duplicati-server \
      --add-flags "$out/share/${pname}-${version}/Duplicati.Server.exe" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
          sqlite ]}
  '';

  meta = with lib; {
    description = "A free backup client that securely stores encrypted, incremental, compressed backups on cloud storage services and remote file servers";
    homepage = "https://www.duplicati.com/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ nyanloutre ];
    platforms = platforms.all;
  };
}
