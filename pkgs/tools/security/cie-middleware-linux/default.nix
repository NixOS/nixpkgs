{ lib
, fetchFromGitHub
, makeWrapper
, strip-nondeterminism
, meson
, ninja
, pkg-config
, gradle_7
, curl
, cryptopp
, fontconfig
, jre
, libxml2
, openssl
, pcsclite
, podofo
, ghostscript
}:

let
  pname = "cie-middleware-linux";
  version = "1.4.4.0";

  src = fetchFromGitHub {
    owner = "M0rf30";
    repo = pname;
    rev = "${version}-podofo";
    sha256 = "sha256-Kyr9OTiY6roJ/wVJS/1aWfrrzDNQbuRTJQqo0akbMUU=";
  };

  gradle = gradle_7;

  # Shared libraries needed by the Java application
  libraries = lib.makeLibraryPath [ ghostscript ];

in

gradle.buildPackage {
  inherit pname src version;

  gradleOpts = {
    depsHash = "sha256-cdssAdKN5riOT6kTMYzBa+r4NmFdRjhdeX/Id0Xv0eM=";
    lockfileTree = ./lockfiles;
    flags = [
      "--parallel"
      "-Dorg.gradle.java.home=${jre}"
      "--build-file" "cie-java/build.gradle"
    ];
  };

  hardeningDisable = [ "format" ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
    strip-nondeterminism
  ];

  buildInputs = [
    cryptopp
    fontconfig
    podofo
    openssl
    pcsclite
    curl
    libxml2
  ];

  postPatch = ''
    # substitute the cieid command with this $out/bin/cieid
    substituteInPlace libs/pkcs11/src/CSP/AbilitaCIE.cpp \
      --replace 'file = "cieid"' 'file = "'$out'/bin/cieid"'
  '';

  # Note: we use pushd/popd to juggle between the
  # libraries and the Java application builds.
  preConfigure = "pushd libs";

  preBuild = ''
    ninjaBuildPhase
    popd
  '';

  postBuild = ''
    pushd libs/build
  '';

  postInstall = ''
    popd

    # Install the Java application
    install -Dm755 cie-java/build/libs/CIEID-standalone.jar \
                   "$out/share/cieid/cieid.jar"

    # Create a wrapper
    mkdir -p "$out/bin"
    makeWrapper "${jre}/bin/java" "$out/bin/cieid" \
      --add-flags "-Djna.library.path='$out/lib:${libraries}'" \
      --add-flags '-Dawt.useSystemAAFontSettings=on' \
      --add-flags "-cp $out/share/cieid/cieid.jar" \
      --add-flags "it.ipzs.cieid.MainApplication"

    # Install other files
    install -Dm644 data/cieid.desktop "$out/share/applications/cieid.desktop"
    install -Dm755 data/logo.png "$out/share/pixmaps/cieid.png"
    install -Dm644 LICENSE "$out/share/licenses/cieid/LICENSE"
  '';

  postFixup = ''
    # Move static libraries to the dev output
    mv -t "$dev/lib" "$out/lib/"*.a

    # Make the jar deterministic (mainly, sorting its files)
    strip-nondeterminism "$out/share/cieid/cieid.jar"
  '';

  meta = with lib; {
    homepage = "https://github.com/M0Rf30/cie-middleware-linux";
    description = "Middleware for the Italian Electronic Identity Card (CIE)";
    longDescription = ''
      Software for the usage of the Italian Electronic Identity Card (CIE).
      Access to PA services, signing and verification of documents

      Warning: this is an unofficial fork because the original software, as
      distributed by the Italian government, is essentially lacking a build
      system and is in violation of the license of the PoDoFo library.
    '';
    license = licenses.bsd3;
    platforms = platforms.unix;
    # Note: fails due to a lot of broken type conversions
    badPlatforms = platforms.darwin;
    maintainers = with maintainers; [ rnhmjoj ];
    # segfaults during build
    broken = true;
  };
}
