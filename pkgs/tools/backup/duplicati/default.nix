{ stdenv, fetchzip, mono, sqlite, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "duplicati";
  version = "2.0.4.5";
  channel = "beta";
  build_date = "2018-11-28";

  src = fetchzip {
    url = "https://github.com/duplicati/duplicati/releases/download/v${version}-${version}_${channel}_${build_date}/duplicati-${version}_${channel}_${build_date}.zip";
    sha256 = "118rhzm8vk1092214vq7kxnmrnz4jl32lk8j90965a8pg05m53gn";
    stripRoot = false;
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}
    makeWrapper "${mono}/bin/mono" $out/bin/duplicati-cli \
      --add-flags "$out/share/${pname}-${version}/Duplicati.CommandLine.exe" \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [
          sqlite ]}
    makeWrapper "${mono}/bin/mono" $out/bin/duplicati-server \
      --add-flags "$out/share/${pname}-${version}/Duplicati.Server.exe" \
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
