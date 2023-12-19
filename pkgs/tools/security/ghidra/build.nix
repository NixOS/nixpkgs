{ stdenv
, fetchFromGitHub
, lib
, gradle_7
, makeWrapper
, openjdk17
, unzip
, makeDesktopItem
, icoutils
, xcbuild
, protobuf
, fetchurl
}:

let
  pkg_path = "$out/lib/ghidra";
  pname = "ghidra";
  version = "10.4";

  src = fetchFromGitHub {
    owner = "NationalSecurityAgency";
    repo = "Ghidra";
    rev = "Ghidra_${version}_build";
    hash = "sha256-g0JM6pm1vkCh9yBB5mfrOiNrImqoyWdQcEe2g+AO6LQ=";
  };

  gradle = gradle_7;

  desktopItem = makeDesktopItem {
    name = "ghidra";
    exec = "ghidra";
    icon = "ghidra";
    desktopName = "Ghidra";
    genericName = "Ghidra Software Reverse Engineering Suite";
    categories = [ "Development" ];
  };

in stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    gradle unzip makeWrapper icoutils protobuf
  ] ++ lib.optional stdenv.isDarwin xcbuild;

  dontStrip = true;

  patches = [
    ./0001-Use-protobuf-gradle-plugin.patch
    # we use fetchurl since the fetchpatch normalization strips the whole diff
    # https://github.com/NixOS/nixpkgs/issues/266556
    (fetchurl {
      name = "0002-remove-executable-bit.patch";
      url = "https://github.com/NationalSecurityAgency/ghidra/commit/e2a945624b74e5d42dc85e9c1f992315dd154db1.diff";
      sha256 = "07mjfl7hvag2akk65g4cknp330qlk07dgbmh20dyg9qxzmk91fyq";
    })
  ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  gradleFlags = [ "-Dorg.gradle.java.home=${openjdk17}" ];

  preBuild = "gradle -I gradle/support/fetchDependencies.gradle init";

  gradleBuildTask = "buildGhidra";

  installPhase = ''
    mkdir -p "${pkg_path}" "$out/share/applications"

    ZIP=build/dist/$(ls build/dist)
    echo $ZIP
    unzip $ZIP -d ${pkg_path}
    f=("${pkg_path}"/*)
    mv "${pkg_path}"/*/* "${pkg_path}"
    rmdir "''${f[@]}"

    ln -s ${desktopItem}/share/applications/* $out/share/applications

    icotool -x "Ghidra/RuntimeScripts/Windows/support/ghidra.ico"
    rm ghidra_4_40x40x32.png
    for f in ghidra_*.png; do
      res=$(basename "$f" ".png" | cut -d"_" -f3 | cut -d"x" -f1-2)
      mkdir -pv "$out/share/icons/hicolor/$res/apps"
      mv "$f" "$out/share/icons/hicolor/$res/apps/ghidra.png"
    done;
  '';

  postFixup = ''
    mkdir -p "$out/bin"
    ln -s "${pkg_path}/ghidraRun" "$out/bin/ghidra"
    wrapProgram "${pkg_path}/support/launch.sh" \
      --prefix PATH : ${lib.makeBinPath [ openjdk17 ]}
  '';

  passthru.updateDeps = gradle.updateDeps { inherit pname; };

  meta = with lib; {
    description = "A software reverse engineering (SRE) suite of tools developed by NSA's Research Directorate in support of the Cybersecurity mission";
    homepage = "https://ghidra-sre.org/";
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [ roblabla ];
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };

}
