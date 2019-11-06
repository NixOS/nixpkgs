{ stdenvNoCC, fetchurl, lib, config, msitools, unzip, static ? false }:

#if !(config.microsoftVisualStudioLicenseAccepted or false)
if false
then throw ''
  Please read

    https://www.visualstudio.com/license-terms/mt644918/

  and change the argument above to `true` if you accept it.
''
else

# How to maintain this.
#
# The root manifest is at https://aka.ms/vs/<version>/release/channel .
# Versions 15 and 16 (2017 and 2019) are confirmed at this time.
#
#   jq '."channelItems" | .[] | select(.id == "Microsoft.VisualStudio.Manifests.VisualStudio") | .payloads | map (. + {"name": .fileName} | del(.fileName) | del(.size))'jq '."channelItems" | .[] | select(.id == "Microsoft.VisualStudio.Manifests.VisualStudio") | .[0]' < VisualStudio.<version>.Release.chman
#
# With the above command, we pull out the main manifest (in a form for fetchgit), which in tern has everything else we need.
#
# TODO(@Ericson2314): automate more.

let
  manifestFile = builtins.fetchurl {
    name = "VisualStudio.vsman";
    url = "https://download.visualstudio.microsoft.com/download/pr/d1553812-31d4-46b0-a480-e6b965eb1125/2d369814247879bf68e8de25fab0b635093ab56a329993f1b9d0c3cc01f001ef/VisualStudio.vsman";
    sha256 = "0lrz0p69p1zznq4xyzjmnp0gy967rb6vh4jckcyzay3gp2567knl";
    # TODO(@Ericson2314): MS claims this hash but it doesn't work. Hashes within
    # are fine. Is something compromised??!?!
    #sha256 = "2d369814247879bf68e8de25fab0b635093ab56a329993f1b9d0c3cc01f001ef";
  };
  manifestUnindexed = builtins.fromJSON (builtins.readFile manifestFile);
  manifest = lib.listToAttrs (map (v: lib.nameValuePair v.id v) manifestUnindexed.packages);

  fetchManifest = id: fetchurl {
    inherit
      (builtins.head manifest.${id}.payloads)
      sha256 url;
  };

  convArchLower = platform: lib.toLower (convArchUpper platform);

  convArchUpper = platform:
         if platform.isx86_64 then "X64"
    else if platform.isx86_32 then "X86"
    else if platform.isAarch32 then "ARM"
    else if platform.isAarch64 then "ARM64"
    else throw "missing platform";

  mkCrt = variant: let
    versionShort = "14.16";
    version = "${versionShort}.27023";
    idLibs    = "Microsoft.VisualC.${versionShort}.CRT.${convArchLower stdenvNoCC.hostPlatform}.${variant}";
    idHeaders = "Microsoft.VisualC.${versionShort}.CRT.Headers";
    srcLibs = fetchManifest idLibs;
    srcHeaders = fetchManifest idHeaders;
  in stdenvNoCC.mkDerivation {
    pname = "${stdenvNoCC.targetPlatform.config}-microsoft-visual-c-crt-${lib.toLower variant}";
    inherit version;
    inherit srcLibs srcHeaders;
    outputs = [ "out" "dev" ];
    nativeBuildInputs = [ unzip ];
    unpackPhase = "true";
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      unzip "$srcLibs" 'Contents/*'
      mkdir "$out"
      mv Contents/VC/Tools/MSVC/${version}/lib/${convArchLower stdenvNoCC.hostPlatform} "$out/lib"
      unzip "$srcHeaders" 'Contents/*'
      mkdir "$dev"
      mv Contents/VC/Tools/MSVC/${version}/include "$dev"
    '';
  };

  windowsSdkVersionMinor = "18362";
  windowsSdkVersion = "10.0.${windowsSdkVersionMinor}.0";

  windowsSdkMetaInstaller = manifest.${"Win10SDK_10.0.${windowsSdkVersionMinor}"};
  windowsSdk = lib.listToAttrs (map (v: lib.nameValuePair v.fileName v) windowsSdkMetaInstaller.payloads);

  fetchWindowsSdk = fileName: fetchurl {
    inherit
      (windowsSdk.${fileName})
      url sha256;
    name = lib.replaceStrings [ " " "%20" ] [ "_" "_" ] (lib.last (lib.splitString "\\" fileName));
  };

  fetchWindowsSdkInstaller = fileName: fetchWindowsSdk ("Installers\\" + fileName);

  extractMsi = msi: srcs: destination: ''
    srcs=(${srcs})
    printLines "''${srcs[@]}"
    for x in "''${srcs[@]}"; do
      cp $x $(echo $x | cut -d- -f2)
    done
    cp "${msi}" ./
    msiextract -C "${destination}" ./*.msi
    rm *.msi
  '';

in lib.makeExtensible (self: {
  msvcTools = let
    version = "14.23.28105";
    id = "Microsoft.VisualCpp.Tools.Host${convArchUpper stdenvNoCC.hostPlatform}.Target${convArchUpper stdenvNoCC.targetPlatform}";
    src = fetchManifest id;
  in stdenvNoCC.mkDerivation {
    pname = "${stdenvNoCC.targetPlatform.config}-microsoft-visual-c-tools";
    inherit version;
    inherit src;
    outputs = [ "out" "aux" "common7" ];
    nativeBuildInputs = [ unzip ];
    unpackPhase = "true";
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      unzip "$src" 'Contents/*'
      mkdir -p "$out"
      mv Contents/VC/Tools/MSVC/${version}/bin/Host${convArchLower stdenvNoCC.hostPlatform}/${convArchLower stdenvNoCC.targetPlatform} "$out/bin"
      mv Contents/VC/Auxiliary "$aux"
      mv Contents/Common7 "$common7"
    '';
  };

  inherit manifest manifestFile;

  crtDesktop = mkCrt "Desktop";

  crtStore = mkCrt "Store";

  windowsSdkDesktopLibs = let
    shortName = "um";
    version = windowsSdkVersion;
  in stdenvNoCC.mkDerivation {
    pname = "windows-sdk-store-desktop-libs";
    version = windowsSdkVersion;
    msi = fetchWindowsSdkInstaller "Windows SDK Desktop Libs ${convArchLower stdenvNoCC.hostPlatform}-x86_en-us.msi";
    srcs = map fetchWindowsSdkInstaller {
      x64 = [
        "58314d0646d7e1a25e97c902166c3155.cab"
      ];
      x86 = [
        "53174a8154da07099db041b9caffeaee.cab"
      ];
    }.${convArchLower stdenvNoCC.hostPlatform};
    nativeBuildInputs = [ msitools ];
    unpackPhase = "true";
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      msiTemp=$(mktemp -d)
      ${extractMsi "$msi" "$srcs" "$msiTemp"}
      mkdir "$out"
      mv "$msiTemp/Program Files/Windows Kits/10/Lib/${version}/um/${convArchLower stdenvNoCC.hostPlatform}" "$out/lib"
    '';
  };

  windowsSdkStoreAppLibs = let
    shortName = "um";
    version = windowsSdkVersion;
  in stdenvNoCC.mkDerivation {
    pname = "windows-sdk-store-app-libs";
    inherit version;
    msiLibs = fetchWindowsSdkInstaller "Windows SDK for Windows Store Apps Libs-x86_en-us.msi";
    srcsLibs = map fetchWindowsSdkInstaller [
      "05047a45609f311645eebcac2739fc4c.cab"
      "0b2a4987421d95d0cb37640889aa9e9b.cab"
      "13d68b8a7b6678a368e2d13ff4027521.cab"
      "463ad1b0783ebda908fd6c16a4abfe93.cab"
      "5a22e5cde814b041749fb271547f4dd5.cab"
      "ba60f891debd633ae9c26e1372703e3c.cab"
      "e10768bb6e9d0ea730280336b697da66.cab"
      "f9b24c8280986c0683fbceca5326d806.cab"
    ];
    msiHeaders = fetchWindowsSdkInstaller "Windows SDK for Windows Store Apps Headers-x86_en-us.msi";
    srcsHeaders = map fetchWindowsSdkInstaller [
      "766c0ffd568bbb31bf7fb6793383e24a.cab"
      "8125ee239710f33ea485965f76fae646.cab"
      "c0aa6d435b0851bf34365aadabd0c20f.cab"
      "c1c7e442409c0adbf81ae43aa0e4351f.cab"
    ];
    nativeBuildInputs = [ msitools ];
    outputs = [ "out" "dev" ];
    unpackPhase = "true";
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      msiTempLibs=$(mktemp -d)
      ${extractMsi "$msiLibs" "$srcsLibs" "$msiTempLibs"}
      mkdir "$out"
      mv "$msiTempLibs/Program Files/Windows Kits/10/Lib/${version}/${shortName}/${convArchLower stdenvNoCC.hostPlatform}" "$out/lib"
      msiTempHeaders=$(mktemp -d)
      ${extractMsi "$msiHeaders" "$srcsHeaders" "$msiTempHeaders"}
      mkdir "$dev"
      mv "$msiTempHeaders/Program Files/Windows Kits/10/Include/${version}/${shortName}" "$dev/include"
    '';
  };

  ucrt = let
    shortName = "ucrt";
    version = windowsSdkVersion;
  in stdenvNoCC.mkDerivation {
    pname = "windows-sdk-${shortName}";
    inherit version;
    msi = fetchWindowsSdkInstaller "Universal CRT Headers Libraries and Sources-x86_en-us.msi";
    srcs = map fetchWindowsSdkInstaller [
      "eca0aa33de85194cd50ed6e0aae0156f.cab"
      "16ab2ea2187acffa6435e334796c8c89.cab"
      "2868a02217691d527e42fe0520627bfa.cab"
      "6ee7bbee8435130a869cf971694fd9e2.cab"
      "78fa3c824c2c48bd4a49ab5969adaaf7.cab"
      "7afc7b670accd8e3cc94cfffd516f5cb.cab"
      "80dcdb79b8a5960a384abe5a217a7e3a.cab"
      "96076045170fe5db6d5dcf14b6f6688e.cab"
      "a1e2a83aa8a71c48c742eeaff6e71928.cab"
      "beb5360d2daaa3167dea7ad16c28f996.cab"
      "f9ff50431335056fb4fbac05b8268204.cab"
      "b2f03f34ff83ec013b9e45c7cd8e8a73.cab"
    ];
    nativeBuildInputs = [ msitools ];
    outputs = [ "out" "dev" "src" ];
    unpackPhase = "true";
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      msiTemp=$(mktemp -d)
      ${extractMsi "$msi" "$srcs" "$msiTemp"}
      mkdir "$out" "$dev"
      mv "$msiTemp/Program Files/Windows Kits/10/Include/${version}/${shortName}" "$dev/include"
      mv "$msiTemp/Program Files/Windows Kits/10/Source/${version}/${shortName}" "$src"
      mv "$msiTemp/Program Files/Windows Kits/10/Lib/${version}/${shortName}/${convArchLower stdenvNoCC.hostPlatform}" "$out/lib"
    '' + lib.optionalString (!static) ''
      mv "$msiTemp/Program Files/Windows Kits/10/bin/${version}/${convArchLower stdenvNoCC.hostPlatform}/${shortName}"/* "$out/lib/"
    '';
  };
})
