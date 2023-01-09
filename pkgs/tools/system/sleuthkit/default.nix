{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, libewf
, afflib
, openssl
, zlib
, openjdk
, perl
, ant
}:

stdenv.mkDerivation rec {
  version = "4.12.0";
  pname = "sleuthkit";

  sleuthsrc = fetchFromGitHub {
    owner = "sleuthkit";
    repo = "sleuthkit";
    rev = "${pname}-${version}";
    hash = "sha256-NX7LNtor7UQJ6HCDz9wGpxbqrLQTTH9+543hOaQOAz4=";
  };

  # Fetch libraries using a fixed output derivation
  rdeps = stdenv.mkDerivation rec {

    version = "1.0";
    pname = "sleuthkit-deps";
    nativeBuildInputs = [
      openjdk
      ant
    ];

    src = sleuthsrc;

    # unpack, build, install
    dontConfigure = true;

    buildPhase = ''
      export IVY_HOME=$NIX_BUILD_TOP/.ant
      pushd bindings/java
      ant retrieve-deps
      popd
      pushd case-uco/java
      ant get-ivy-dependencies
      popd
    '';

    installPhase = ''
      export IVY_HOME=$NIX_BUILD_TOP/.ant
      mkdir -m 755 -p $out/bindings/java
      cp -r bindings/java/lib $out/bindings/java
      mkdir -m 755 -p $out/case-uco/java
      cp -r case-uco/java/lib $out/case-uco/java
      cp -r $IVY_HOME/lib $out
      chmod -R 755 $out/lib
    '';

    outputHashMode = "recursive";
    outputHash = "0fq7v6zlgybg4v6k9wqjlk4gaqgjrpihbnr182vaqriihflav2s8";
    outputHashAlgo = "sha256";
  };

  src = sleuthsrc;

  postPatch = ''
    substituteInPlace tsk/img/ewf.cpp --replace libewf_handle_read_random libewf_handle_read_buffer_at_offset
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    openjdk
    perl
    ant
    rdeps
  ];

  buildInputs = [
    libewf
    afflib
    openssl
    zlib
  ];

  # Hack to fix the RPATH
  preFixup = ''
    rm -rf */.libs
  '';

  postUnpack = ''
    export IVY_HOME="$NIX_BUILD_TOP/.ant"
    export JAVA_HOME="${openjdk}"
    export ant_args="-Doffline=true -Ddefault-jar-location=$IVY_HOME/lib"

    # pre-positioning these jar files allows -Doffline=true to work
    mkdir -p source/{bindings,case-uco}/java $IVY_HOME
    cp -r ${rdeps}/bindings/java/lib source/bindings/java
    chmod -R 755 source/bindings/java
    cp -r ${rdeps}/case-uco/java/lib source/case-uco/java
    chmod -R 755 source/case-uco/java
    cp -r ${rdeps}/lib $IVY_HOME
    chmod -R 755 $IVY_HOME
  '';

  meta = with lib; {
    description = "A forensic/data recovery tool";
    homepage = "https://www.sleuthkit.org/";
    changelog = "https://github.com/sleuthkit/sleuthkit/releases/tag/sleuthkit-${version}";
    maintainers = with maintainers; [ raskin gfrascadorio ];
    platforms = platforms.linux;
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # dependencies
    ];
    license = licenses.ipl10;
  };
}
