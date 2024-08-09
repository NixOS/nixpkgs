{ lib
, stdenvNoCC
, fetchFromGitHub
, requireFile
, autoPatchelfHook
, unzip
, xdelta
, jre
, androidenv

# 32 bit packages inherited from `all-packages.nix`.
, stdenv32Bit
, libX11
, libXext
, libXrandr
, libXxf86vm
, openal
, libGLU
, libglvnd
, libzip
, curl

# Include higher quality music with the cost of a bigger file size.
, highQualityMusic ? true
# Build an Android APK instead of a Linux binary.
, androidApk ? false
# Mods for AM2R are distributed as custom clients, to be patched in place. This should refer to a directory containing the patches.
, customClient ? null

, am2r_zip ? requireFile {
    name = "AM2R_11.zip";
    message = ''
      This nix expression requires that 'AM2R_11.zip' is already part of the store.
      You can then add it the nix store with 'nix-store --add-fixed sha256 AM2R_11.zip'.
    '';
    sha256 = "sha256-+j0JMbr4shi2qLTOnrjhjKEeFCw08LQE1AXYMA7w+kw=";
  }
}:

let
  # A 32-bit stdenv is required on Linux for autoPatchelfHook, as the target binary is 32-bit.
  # For the android build we never need to patch any binaries, so we can use the regular stdenv.
  stdenv' = if androidApk then stdenvNoCC else stdenv32Bit;
in
stdenv'.mkDerivation rec {
  pname = "am2r";
  version = "29";

  src = fetchFromGitHub {
    owner = "AM2R-Community-Developers";
    repo = "AM2R-Autopatcher-Linux";
    rev = "Patchdata-v${version}";
    sha256 = "sha256-WMYm/J1AGUA+VzVS7PW2GSMT71YQLLAzJNiRJkt4yPk=";
  };

  nativeBuildInputs = [
    unzip
    xdelta
  ] ++ lib.optional (!androidApk) autoPatchelfHook
    ++ lib.optional androidApk jre;

  buildInputs = lib.optionals (!androidApk) [
    stdenv32Bit.cc.cc.lib
    libX11
    libXext
    libXrandr
    libXxf86vm
    openal
    libGLU
    libglvnd
    libzip
    curl
  ];

  # The patcher script executes a java application to sign Android APKs, which in turn attempts to
  # execute a native binary. Manually specify the path to it instead to avoid dynamic linker issues.
  postPatch = let
    build-tools = builtins.head androidenv.androidPkgs_9_0.build-tools;
    zipalign = "${build-tools}/libexec/android-sdk/build-tools/${build-tools.version}/zipalign";
  in lib.optionalString androidApk ''
    substituteInPlace ./patcher.sh \
      --replace 'java -jar "$uberPath"' 'java -jar "$uberPath" --zipAlignPath ${zipalign}'
  '';

  configurePhase = ''
    runHook preConfigure

    patchShebangs ./patcher.sh
  '' + lib.optionalString (customClient != null) ''
    cp -r ${customClient}/* ./data
    chmod -R u+w ./data
  '' + ''
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -p ./output
    ./patcher.sh \
      --prefix ./output \
      --am2rzip ${am2r_zip} \
      ${lib.optionalString highQualityMusic "--hqmusic"} \
      --os ${if androidApk then "android" else "linux --systemwide"}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ./output/* $out
    ln -sf $out/opt/am2r/runner $out/bin/am2r
    ln -s $out/opt/am2r/.runner-unwrapped $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/AM2R-Community-Developers/AM2R-Autopatcher-Linux";
    description = "A fan-made remake of Metroid II: Return of Samus in the style of Metroid: Zero Mission";
    longDescription = ''
      Unofficial AM2R Community Updates, a fan-made remake of Metroid II: Return of Samus in the style of Metroid: Zero Mission.
      A reconstruction of the original AM2R release, bringing more features such as widescreen and a built-in randomizer.
      You must provide your own AM2R_1.1 zip file for patching. It can be added to the store with 'nix-store --add-fixed sha256 AM2R_11.zip'.
    '' + lib.optionalString androidApk ''
      This will build an Android APK of AM2R, to be installed on your mobile device.
    '';
    license = with licenses; [
      gpl3Only # The patching utility.
      unfree # The game itself, provided through `requireFile`.
    ] ++ lib.optional androidApk asl20; # From a dependency needed to build the APK.
    platforms = if androidApk then platforms.unix else [ "i686-linux" ];
    maintainers = with maintainers; [ ivar ];
  };
}
