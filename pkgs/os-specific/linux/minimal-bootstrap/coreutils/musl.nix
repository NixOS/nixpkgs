{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bash
, tinycc
, gnumake
, gnugrep
, gnused
, gawk
, gnutar
, gzip
}:
let
  pname = "bootstrap-coreutils-musl";
  version = "9.4";

  src = fetchurl {
    url = "mirror://gnu/coreutils/coreutils-${version}.tar.gz";
    hash = "sha256-X2ANkJOXOwr+JTk9m8GMRPIjJlf0yg2V6jHHAutmtzk=";
  };

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--build=${buildPlatform.config}"
    "--host=${hostPlatform.config}"
    # musl 1.1.x doesn't use 64bit time_t
    "--disable-year2038"
    # libstdbuf.so fails in static builds
    "--enable-no-install-program=stdbuf"
  ];
in
bash.runCommand "${pname}-${version}" {
  inherit pname version;

  nativeBuildInputs = [
    tinycc.compiler
    gnumake
    gnused
    gnugrep
    gawk
    gnutar
    gzip
  ];

  passthru.tests.get-version = result:
    bash.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/cat --version
      mkdir $out
    '';

  meta = with lib; {
    description = "GNU Core Utilities";
    homepage = "https://www.gnu.org/software/coreutils";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
} ''
  # Unpack
  tar xzf ${src}
  cd coreutils-${version}

  # Configure
  export CC="tcc -B ${tinycc.libs}/lib"
  export LD=tcc
  bash ./configure ${lib.concatStringsSep " " configureFlags}

  # Build
  make -j $NIX_BUILD_CORES AR="tcc -ar" MAKEINFO="true"

  # Install
  make -j $NIX_BUILD_CORES install MAKEINFO="true"
''
