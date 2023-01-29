# see also
# https://github.com/radareorg/radare2-pm/blob/master/db/r2ghidra
# https://github.com/radareorg/radare2-pm/blob/master/db/r2ghidra-sleigh

{ lib
, clangStdenv
, fetchFromGitHub
, buildPackages
, pkg-config
, meson
, ninja
, radare2
}:

clangStdenv.mkDerivation rec {
  pname = "r2ghidra";
  version = "5.8.2";

  src = fetchFromGitHub {
    owner = "radareorg";
    repo = "r2ghidra";
    rev = version;
    sha256 = "sha256-vAccsANhMoAMWgsYSK7DI1OmJQeQRPazOMJlAxRsa+g=";
    fetchSubmodules = true;
  };

  # https://github.com/radareorg/r2ghidra/blob/master/ghidra/Makefile
  # GHIDRA_NATIVE_COMMIT
  # https://github.com/radareorg/r2ghidra/blob/5.8.2/Makefile
  # https://github.com/radareorg/ghidra-native
  # https://github.com/radareorg/r2ghidra/issues/100
  ghidra-native-src = fetchFromGitHub {
    owner = "radareorg";
    repo = "ghidra-native";
    rev = "0.2.5";
    sha256 = "sha256-dycOFz0ZBXbPAuFobvxJkdFWzSETilcBdMf1KLtl5JY=";
  };

  # https://github.com/NationalSecurityAgency/ghidra/tree/master/Ghidra/Processors
  ghidra-processors-src = fetchFromGitHub {
    owner = "NationalSecurityAgency";
    repo = "ghidra";
    rev = "Ghidra_10.2.2_build";
    # 6 of 240 MB
    sparseCheckout = ''
      Ghidra/Processors
    '';
    sha256 = "sha256-g1efLVLoFQYqoaFAYGy/lfrPx2ZfXEhp0ZsJH9ew7XE=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    radare2
  ];

  # need write-access for patch + build
  postUnpack = ''
    cp -r ${ghidra-native-src} source/ghidra-native
    chmod -R +w source/ghidra-native
    cp -r ${ghidra-processors-src}/Ghidra source/ghidra/src
    chmod -R +w source/ghidra/src
  '';

  NIX_CFLAGS_COMPILE = [
    "-O1" # fortify
    # hide warnings
    "-Wno-return-stack-address"
    "-Wno-unused-variable"
    "-Wno-unused-function"
    "-Wno-reorder-ctor"
    "-Wno-switch"
    "-Wno-pessimizing-move"
    "-Wno-unneeded-internal-declaration"
    "-Wno-mismatched-tags"
    "-Wno-unused-result"
    "-Wno-macro-redefined"
  ];

  # https://github.com/radareorg/r2ghidra/blob/master/preconfigure
  postPatch = ''
    echo "Patching install prefix in meson.build"
    sed -i.bak "s|^  r2_plugdir = res.stdout().strip()$|&.replace('${radare2.out}', '$out')|" meson.build
    diff -u meson.build{.bak,} || true
    rm meson.build.bak

    echo "Patching radare2 library path"
    substituteInPlace src/SleighAsm.cpp \
      --replace \
        'path = strdup (R2_PREFIX "/lib/radare2/" R2_VERSION "/r2ghidra_sleigh");' \
        'path = strdup ("'$out'" "/lib/radare2/" R2_VERSION "/r2ghidra_sleigh");'

    echo "Patching ghidra-native"
    make -C ghidra-native patch
  '';

  # workround for https://github.com/radareorg/r2ghidra/issues/93
  # https://github.com/radareorg/r2ghidra/blob/master/ghidra/Makefile
  postBuild = ''
    GHIDRA_SLEIGH_HOME=../ghidra/src/Processors
    cp -v ../ghidra-processors.txt.default ../ghidra-processors.txt
    echo "Compiling processor files"
    ./sleighc -a $GHIDRA_SLEIGH_HOME/DATA
    cat ../ghidra-processors.txt | sed "s|^|$GHIDRA_SLEIGH_HOME/|" | xargs -n1 -P$NIX_BUILD_CORES ./sleighc -a 2>/dev/null
  '';

  # TODO use radare2.abiVersion https://github.com/radareorg/radare2/pull/20545
  postInstall = ''
    echo "Installing processor files to $out/lib/radare2/${radare2.version}/r2ghidra_sleigh"
    mkdir $out/lib/radare2/${radare2.version}/r2ghidra_sleigh
    for a in DATA $(cat ../ghidra-processors.txt); do
      for b in $GHIDRA_SLEIGH_HOME/$a/*/*/*.{cspec,ldefs,pspec,sla}; do
        cp $b $out/lib/radare2/${radare2.version}/r2ghidra_sleigh
      done
    done
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Native Ghidra Decompiler for radare2";
    homepage = "https://github.com/radareorg/r2ghidra";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ milahu ];
    platforms = platforms.unix;
  };
}
