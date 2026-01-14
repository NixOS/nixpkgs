{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  tinycc,
  gnumake,
  gnugrep,
  gnused,
  gawk,
  gnutar,
  gzip,
}:
let
  inherit (import ./common.nix { inherit lib; }) meta;
  pname = "bootstrap-coreutils-musl";
  version = "9.9";

  src = fetchurl {
    url = "mirror://gnu/coreutils/coreutils-${version}.tar.gz";
    hash = "sha256-kacZ/Pkj3mhgFvLI0ISovh95PzQXOGEnPEZo98Za+Uo=";
  };

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--build=${buildPlatform.config}"
    "--host=${hostPlatform.config}"
    "--disable-dependency-tracking"
    # libstdbuf.so fails in static builds
    "--enable-no-install-program=stdbuf,arch,coreutils,hostname"
    # Disable PATH_MAX for better reproducibility
    "gl_cv_func_getcwd_path_max=\"no, but it is partly working\""
    "gl_cv_have_unlimited_file_name_length=no"

    # test crashes bash-2.05b?
    "gl_cv_func_pthread_rwlock_good_waitqueue=no"

    # depends on linux/version.h, which is not present at this stage
    "gl_cv_func_copy_file_range=no"
    "gl_cv_onwards_func_copy_file_range=no"
  ];
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version meta;

    nativeBuildInputs = [
      tinycc.compiler
      gnumake
      gnused
      gnugrep
      gawk
      gnutar
      gzip
    ];

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/cat --version
        mkdir $out
      '';
  }
  ''
    # Unpack
    tar xzf ${src}
    cd coreutils-${version}

    # Configure
    export CC="tcc -B ${tinycc.libs}/lib"
    export LD=tcc
    export LDFLAGS="-L ./lib"
    bash ./configure ${lib.concatStringsSep " " configureFlags}

    # Build
    #
    # Set SUBDIRS=. to avoid cd'ing to gnulib-tests. Those have
    # compilation issues related to pthread and linux/*.h not
    # being available.
    make -j $NIX_BUILD_CORES AR="tcc -ar" MAKEINFO="true" SUBDIRS=.

    # Install
    make -j $NIX_BUILD_CORES install MAKEINFO="true" SUBDIRS=.
  ''
