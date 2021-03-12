{ lib, stdenv, fetchurl, dotnetCorePackages, makeWrapper, curl, icu60, openssl, zlib, nixosTests }:

let
  suffix = {
    x86_64-linux = "LinuxAMDx64";
    aarch64-linux = "LinuxARM64";
    x86_64-darwin = "macOS";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  hash = {
    x86_64-linux = "1mpm8kji4npc44cs51r75xxdq74gxxdnfffazlbgypcabcb46gzp";
    aarch64-linux = "18slsjzqs52frmbq6a0c3zrpa5fgf9sfxmzbkrffllc8m54rhcjn";
    x86_64-darwin = "161df7s2skg8wbd7kpbs9qhyka0ywqcbc44zpz4c16mvax0a6wls";
  }."${stdenv.hostPlatform.system}";

in stdenv.mkDerivation rec {
  pname = "jackett";
  version = "0.17.677";

  src = fetchurl {
    url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.${suffix}.tar.gz";
    sha256 = hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}

    makeWrapper "${dotnetCorePackages.netcore_3_1}/bin/dotnet" $out/bin/Jackett \
      --add-flags "$out/share/${pname}-${version}/jackett.dll" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ curl icu60 openssl zlib ]}
  '';

  passthru.tests = {
    smoke-test = nixosTests.jackett;
  };

  meta = with lib; {
    description = "API Support for your favorite torrent trackers";
    homepage = "https://github.com/Jackett/Jackett/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ edwtjo nyanloutre purcell ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
