{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bash
, gnumake
, gnupatch
, gnugrep
, gnutar
, gawk
, bzip2
, sed
, mesBootstrap ? false, tinycc ? null
, gcc ? null, glibc ? null, binutils ? null, linux-headers
}:
assert mesBootstrap -> tinycc != null;
assert !mesBootstrap -> gcc != null && glibc != null && binutils != null;
let
  pname = "binutils" + lib.optionalString mesBootstrap "-mes";
  version = "2.20.1";
  rev = "a";

  src = fetchurl {
    url = "mirror://gnu/binutils/binutils-${version}${rev}.tar.bz2";
    sha256 = "0r7dr0brfpchh5ic0z9r4yxqn4ybzmlh25sbp30cacqk8nb7rlvi";
  };

  patches = [
    # Enables building binutils using TCC and Mes C Library
    (fetchurl {
      url = "https://git.savannah.gnu.org/cgit/guix.git/plain/gnu/packages/patches/binutils-boot-2.20.1a.patch?id=50249cab3a98839ade2433456fe618acc6f804a5";
      sha256 = "086sf6an2k56axvs4jlky5n3hs2l3rq8zq5d37h0b69cdyh7igpn";
    })

    # Make binutils output deterministic by default.
    ./deterministic.patch
  ];

  configureFlags = [
    "--disable-nls"
    "--disable-shared"
    "--disable-werror"
    "--prefix=${placeholder "out"}"

    "--build=${buildPlatform.config}"
    "--host=${hostPlatform.config}"

    # Turn on --enable-new-dtags by default to make the linker set
    # RUNPATH instead of RPATH on binaries.  This is important because
    # RUNPATH can be overridden using LD_LIBRARY_PATH at runtime.
    "--enable-new-dtags"

    # By default binutils searches $libdir for libraries. This brings in
    # libbfd and libopcodes into a default visibility. Drop default lib
    # path to force users to declare their use of these libraries.
    "--with-lib-path=:"
  ];
in
bash.runCommand "${pname}-${version}" {
  inherit pname version;

  nativeBuildInputs = [
    (if mesBootstrap then tinycc.compiler else gcc)
    gnumake
    gnupatch
    gnugrep
    gnutar
    gawk
    bzip2
    sed
  ] ++ lib.optional (!mesBootstrap) binutils;

  passthru.tests.get-version = result:
    bash.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/ld --version
      mkdir $out
    '';

  meta = with lib; {
    description = "Tools for manipulating binaries (linker, assembler, etc.)";
    homepage = "https://www.gnu.org/software/binutils";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
} ''
  # Unpack
  cp ${src} binutils.tar.bz2
  bunzip2 binutils.tar.bz2
  tar xf binutils.tar
  rm binutils.tar
  cd binutils-${version}

  # Patch
  ${lib.concatMapStringsSep "\n" (f: "patch -Np1 -i ${f}") patches}
  # Clear the default library search path.
  echo 'NATIVE_LIB_DIRS=' >> ld/configure.tgt

  # Configure
  ${if mesBootstrap then ''
    export CC="tcc -B ${tinycc.libs}/lib -D __GLIBC_MINOR__=6 -D MES_BOOTSTRAP=1"
    export AR="tcc -ar"
  '' else ''
    export CC="gcc -B ${glibc}/lib -I${glibc}/include -I${linux-headers}/include"
    export CPP="gcc -E -I${glibc}/include -I${linux-headers}/include"
    export AR="ar"
    export LIBRARY_PATH="${glibc}/lib"
    export LIBS="-lc -lnss_files -lnss_dns -lresolv"
  ''}
  export SED=sed
  bash ./configure ${lib.concatStringsSep " " configureFlags}

  # Build
  make

  # Install
  make install
''
