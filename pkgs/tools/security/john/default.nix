{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  nss,
  nspr,
  libkrb5,
  gmp,
  zlib,
  libpcap,
  re2,
  gcc,
  python3Packages,
  perl,
  perlPackages,
  withOpenCL ? true,
  opencl-headers,
  ocl-icd,
  substituteAll,
  makeWrapper,
  withSIMD ?
    if stdenv.buildPlatform.isx86 then
      [
        "avx512bw"
        "avx512f"
        "avx2"
        "xop"
        "avx"
        "sse2"
        false
      ]
    else
      [ false ],
  withOpenMP ? [
    true
    false
  ],
  callPackage,
}@args:

let
  toCString =
    s:
    "\""
    + (lib.strings.escapeC [
      "\""
      "\\"
      "\r"
      "\n"
    ] s)
    + "\"";
in
stdenv.mkDerivation rec {
  pname = "john";
  version = "rolling-2404";

  src = fetchFromGitHub {
    owner = "openwall";
    repo = "john";
    rev = "f9fedd238b0b1d69181c1fef033b85c787e96e57";
    hash = "sha256-zvoN+8Sx6qpVg2JeRLOIH1ehfl3tFTv7r5wQZ44Qsbc=";
  };

  patches = lib.optionals withOpenCL [
    (substituteAll {
      src = ./opencl.patch;
      ocl_icd = ocl-icd;
    })
  ];

  postPatch = ''
    sed -ri -e '
      s!^(#define\s+CFG_[A-Z]+_NAME\s+).*/!\1"'"$out"'/etc/john/!
      /^#define\s+JOHN_SYSTEMWIDE/s!/usr!'"$out"'!
    ' src/params.h
    sed -ri -e '/^\.include/ {
      s!\$JOHN!'"$out"'/etc/john!
      s!^(\.include\s*)<([^./]+\.conf)>!\1"'"$out"'/etc/john/\2"!
    }' run/*.conf
  '';

  # john has a "fallback chain" mechanism; whenever the john binary
  # encounters that it is built for a SIMD target that is not supported
  # by the current CPU, it can fall back to another binary that is not
  # built to expect that feature, continuing until it eventually reaches
  # a compatible binary. See:
  # https://github.com/openwall/john/blob/bleeding-jumbo/src/packaging/build.sh
  # https://github.com/openwall/john/blob/bleeding-jumbo/doc/README-DISTROS
  # https://github.com/NixOS/nixpkgs/issues/328226
  passthru.cpuFallback = (callPackage ./default.nix (args // { withSIMD = lib.tail withSIMD; }));
  passthru.ompFallback = (callPackage ./default.nix (args // { withOpenMP = lib.tail withOpenMP; }));

  preConfigure =
    ''
      cd src
      # Makefile.in depends on AS and LD being set to CC, which is set by default in configure.ac.
      # This ensures we override the environment variables set in cc-wrapper/setup-hook.sh
      export AS=$CC
      export LD=$CC
    ''
    + lib.optionalString withOpenCL ''
      python ./opencl_generate_dynamic_loader.py  # Update opencl_dynamic_loader.c
    '';
  cppFlags =
    [
      # To run a fallback, john execs "${JOHN_SYSTEMWIDE_EXEC}/${XXX_FALLBACK_BINARY}"
      "-DJOHN_SYSTEMWIDE_EXEC=${lib.escapeShellArg (toCString "")}"
    ]
    ++ (lib.optionals (lib.tail withSIMD != [ ]) [
      "-DCPU_FALLBACK"
      "-DCPU_FALLBACK_BINARY=${lib.escapeShellArg (toCString "${lib.removePrefix "/" passthru.cpuFallback}/bin/john")}"
    ])
    ++ (lib.optionals (lib.tail withOpenMP != [ ]) [
      "-DOMP_FALLBACK"
      "-DOMP_FALLBACK_BINARY=${lib.escapeShellArg (toCString "${lib.removePrefix "/" passthru.ompFallback}/bin/john")}"
    ]);
  __structuredAttrs = true;
  configureFlags = [
    "--disable-native-tests"
    "--with-systemwide"
    (if lib.head withSIMD != false then "--enable-simd=${lib.head withSIMD}" else "--disable-simd")
    (if lib.head withOpenMP then "--enable-openmp" else "--disable-openmp")
    "CPPFLAGS=${builtins.concatStringsSep " " cppFlags}"
  ];

  buildInputs =
    [
      openssl
      nss
      nspr
      libkrb5
      gmp
      zlib
      libpcap
      re2
    ]
    ++ lib.optionals withOpenCL [
      opencl-headers
      ocl-icd
    ];
  nativeBuildInputs = [
    gcc
    python3Packages.wrapPython
    perl
    makeWrapper
  ];
  propagatedBuildInputs =
    # For pcap2john.py
    (with python3Packages; [
      dpkt
      scapy
      lxml
    ])
    ++ (with perlPackages; [
      # For pass_gen.pl
      DigestMD4
      DigestSHA1
      GetoptLong
      # For 7z2john.pl
      CompressRawLzma
      # For sha-dump.pl
      perlldap
    ]);
  # TODO: Get dependencies for radius2john.pl and lion2john-alt.pl

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p "$out/bin" "$out/etc/john" "$out/share/john" "$out/share/doc/john" "$out/share/john/rules" "$out/${perlPackages.perl.libPrefix}"
    find -L ../run -mindepth 1 -maxdepth 1 -type f -executable \
      -exec cp -d {} "$out/bin" \;
    cp -vt "$out/etc/john" ../run/*.conf
    cp -vt "$out/share/john" ../run/*.chr ../run/password.lst
    cp -vt "$out/share/john/rules" ../run/rules/*.rule
    cp -vrt "$out/share/doc/john" ../doc/*
    cp -vt "$out/${perlPackages.perl.libPrefix}" ../run/lib/*
  '';

  postFixup = ''
    wrapPythonPrograms

    for i in $out/bin/*.pl; do
      wrapProgram "$i" --prefix PERL5LIB : "$PERL5LIB:$out/${perlPackages.perl.libPrefix}"
    done
  '';

  meta = with lib; {
    description = "John the Ripper password cracker";
    license = licenses.gpl2Plus;
    homepage = "https://github.com/openwall/john/";
    maintainers = with maintainers; [
      offline
      matthewbauer
      cherrykitten
    ];
    platforms = platforms.unix;
  };
}
