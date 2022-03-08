{ lib, stdenv, fetchurl, dotnet-runtime }:

with lib;
stdenv.mkDerivation rec {
  pname = "dottrace";
  version = "2021.3.3";

  src = fetchurl {
    url = "https://download.jetbrains.com/resharper/dotUltimate.${version}/JetBrains.dotTrace.CommandLineTools.linux-x64.${version}.tar.gz";
    sha256 = "sha256-PcJX0IO/P0i3Am3MEZuauX9FQeX9ojxzWCnxIDekPNo=";
  };

  unpackPhase = ''
    mkdir dist
    cd dist
    tar -xzf ${src}
  '';

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/dist
    mkdir -p $out/bin
    cp -r ./ $out/dist
    rm -rf $out/dist/dotnet #removing bundled dotnet
    ln -s $out/dist/dottrace $out/bin/dottrace
  '';

  postFixup = ''
    substituteInPlace $out/dist/runtime-dotnet.sh --replace 'dotnet="$root/$platform-$architecture/dotnet"' 'dotnet=${dotnet-runtime}'
    substituteInPlace $out/bin/dottrace --replace 'root=$(dirname "$0")' 'root=$(dirname "$0")/../dist'
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/dottrace | grep ${version}
  '';

  meta = {
    description = ".NET Performance Profiler CLI";
    homepage = "https://www.jetbrains.com/profiler/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.gbtb ];
  };
}
