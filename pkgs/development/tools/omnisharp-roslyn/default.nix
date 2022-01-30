{ lib, stdenv
, fetchFromGitHub
, fetchurl
, mono6
, msbuild
, dotnetCorePackages
, makeWrapper
, unzip
, writeText
}:

let

  dotnet-sdk = dotnetCorePackages.sdk_5_0;

  deps = map (package: stdenv.mkDerivation (with package; {
    inherit pname version src;

    buildInputs = [ unzip ];
    unpackPhase = ''
      unzip $src
      chmod -R u+r .
      function traverseRename () {
        for e in *
        do
          t="$(echo "$e" | sed -e "s/%20/\ /g" -e "s/%2B/+/g")"
          [ "$t" != "$e" ] && mv -vn "$e" "$t"
          if [ -d "$t" ]
          then
            cd "$t"
            traverseRename
            cd ..
          fi
        done
      }

      traverseRename
    '';

    installPhase = ''
      runHook preInstall

      package=$out/lib/dotnet/${pname}/${version}
      mkdir -p $package
      cp -r . $package
      echo "{}" > $package/.nupkg.metadata

      runHook postInstall
    '';

    dontFixup = true;
  }))
    (import ./deps.nix { inherit fetchurl; });

  nuget-config = writeText "NuGet.Config" ''
    <?xml version="1.0" encoding="utf-8"?>
    <configuration>
      <packageSources>
        <clear />
      </packageSources>
      <fallbackPackageFolders>
        ${lib.concatStringsSep "\n" (map (package: "<add key=\"${package}\" value=\"${package}/lib/dotnet\"/>") deps)}
      </fallbackPackageFolders>
    </configuration>
  '';

in stdenv.mkDerivation rec {

  pname = "omnisharp-roslyn";
  version = "1.37.15";

  src = fetchFromGitHub {
    owner = "OmniSharp";
    repo = pname;
    rev = "v${version}";
    sha256 = "070wqs667si3f78fy6w4rrfm8qncnabg0yckjhll0yv1pzbj9q42";
  };

  nativeBuildInputs = [ makeWrapper msbuild ];

  buildPhase = ''
    runHook preBuild

    HOME=$(pwd)/fake-home msbuild -r \
      -p:Configuration=Release \
      -p:RestoreConfigFile=${nuget-config} \
      src/OmniSharp.Stdio.Driver/OmniSharp.Stdio.Driver.csproj

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r bin/Release/OmniSharp.Stdio.Driver/net472 $out/src
    cp bin/Release/OmniSharp.Host/net472/SQLitePCLRaw* $out/src
    mkdir $out/src/.msbuild
    ln -s ${msbuild}/lib/mono/xbuild/* $out/src/.msbuild/
    rm $out/src/.msbuild/Current
    mkdir $out/src/.msbuild/Current
    ln -s ${msbuild}/lib/mono/xbuild/Current/* $out/src/.msbuild/Current/
    ln -s ${msbuild}/lib/mono/msbuild/Current/bin $out/src/.msbuild/Current/Bin

    makeWrapper ${mono6}/bin/mono $out/bin/omnisharp \
      --suffix PATH : ${dotnet-sdk}/bin \
      --add-flags "$out/src/OmniSharp.exe"
  '';

  meta = with lib; {
    description = "OmniSharp based on roslyn workspaces";
    homepage = "https://github.com/OmniSharp/omnisharp-roslyn";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ tesq0 ericdallo corngood ];
  };

}
