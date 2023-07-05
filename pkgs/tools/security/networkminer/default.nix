{ lib
, buildDotnetModule
, fetchurl
, unzip
, dos2unix
, makeWrapper
, msbuild
, mono
}:
buildDotnetModule rec {
  pname = "networkminer";
  version = "2.8";

  src = fetchurl {
    # Upstream does not provide versioned releases, a mirror has been uploaded
    # to archive.org
    url = "https://archive.org/download/networkminer-${lib.replaceStrings ["."] ["-"] version}/NetworkMiner_${lib.replaceStrings ["."] ["-"] version}_source.zip";
    sha256 = "1n2312acq5rq0jizlcfk0crslx3wgcsd836p47nk3pnapzw0cqvv";
  };

  nativeBuildInputs = [ unzip dos2unix msbuild ];

  patches = [
    # Store application data in XDG_DATA_DIRS instead of trying to write to nix store
    ./xdg-dirs.patch
  ];

  postPatch = ''
    # Not all files have UTF-8 BOM applied consistently
    find . -type f -exec dos2unix -m {} \+

    # Embedded base64-encoded app icon in resx fails to parse. Delete it
    sed -zi 's|<data name="$this.Icon".*</data>||g' NetworkMiner/NamedPipeForm.resx
    sed -zi 's|<data name="$this.Icon".*</data>||g' NetworkMiner/UpdateCheck.resx
  '';

  nugetDeps = ./deps.nix;

  buildPhase = ''
    runHook preBuild

    msbuild /p:Configuration=Release NetworkMiner.sln

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -r NetworkMiner/bin/Release $out/share/NetworkMiner
    makeWrapper ${mono}/bin/mono $out/bin/NetworkMiner \
      --add-flags "$out/share/NetworkMiner/NetworkMiner.exe" \
      --add-flags "--noupdatecheck"

    install -D NetworkMiner/NetworkMiner.desktop $out/share/applications/NetworkMiner.desktop
    substituteInPlace $out/share/applications/NetworkMiner.desktop \
      --replace "Exec=mono NetworkMiner.exe %f" "Exec=NetworkMiner" \
      --replace "Icon=./networkminericon-96x96.png" "Icon=NetworkMiner"
    install -D NetworkMiner/networkminericon-96x96.png $out/share/pixmaps/NetworkMiner.png

    runHook postInstall
  '';

  meta = with lib; {
    description = "The Open Source Network Forensic Analysis Tool (NFAT)";
    homepage = "https://www.netresec.com/?page=NetworkMiner";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.linux;
    mainProgram = "NetworkMiner";
  };
}
