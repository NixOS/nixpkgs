{ lib, stdenv
, fetchFromGitHub
, fetchurl
, dotnetCorePackages
, makeWrapper
, unzip
, writeText
}:

let

  dotnet-sdk = dotnetCorePackages.sdk_6_0;

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
  version = "1.38.0";

  src = fetchFromGitHub {
    owner = "OmniSharp";
    repo = pname;
    rev = "v${version}";
    sha256 = "00V+7Z1IoCSuSM0RClM81IslzCzC/FNYxHIKtnI9QDg=";
  };

  nativeBuildInputs = [ makeWrapper dotnet-sdk ];

  buildPhase = ''
    runHook preBuild

    HOME=$(pwd)/fake-home dotnet msbuild -r \
      -p:Configuration=Release \
      -p:RestoreConfigFile=${nuget-config} \
      src/OmniSharp.Stdio.Driver/OmniSharp.Stdio.Driver.csproj

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r bin/Release/OmniSharp.Stdio.Driver/net6.0 $out/src
    makeWrapper $out/src/OmniSharp $out/bin/omnisharp \
      --prefix DOTNET_ROOT : ${dotnet-sdk} \
      --suffix PATH : ${dotnet-sdk}/bin
  '';

  meta = with lib; {
    description = "OmniSharp based on roslyn workspaces";
    homepage = "https://github.com/OmniSharp/omnisharp-roslyn";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ tesq0 ericdallo corngood ];
  };

}
