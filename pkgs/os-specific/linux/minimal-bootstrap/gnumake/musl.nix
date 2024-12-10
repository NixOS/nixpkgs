{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  tinycc,
  gnumakeBoot,
  gnupatch,
  gnused,
  gnugrep,
  gawk,
  gnutar,
  gzip,
}:
let
  pname = "gnumake-musl";
  version = "4.4.1";

  src = fetchurl {
    url = "mirror://gnu/make/make-${version}.tar.gz";
    hash = "sha256-3Rb7HWe/q3mnL16DkHNcSePo5wtJRaFasfgd23hlj7M=";
  };

  patches = [
    # Replaces /bin/sh with sh, see patch file for reasoning
    ./0001-No-impure-bin-sh.patch
    # Purity: don't look for library dependencies (of the form `-lfoo') in /lib
    # and /usr/lib. It's a stupid feature anyway. Likewise, when searching for
    # included Makefiles, don't look in /usr/include and friends.
    ./0002-remove-impure-dirs.patch
  ];
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version;

    nativeBuildInputs = [
      tinycc.compiler
      gnumakeBoot
      gnupatch
      gnused
      gnugrep
      gawk
      gnutar
      gzip
    ];

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/make --version
        mkdir $out
      '';

    meta = with lib; {
      description = "Tool to control the generation of non-source files from sources";
      homepage = "https://www.gnu.org/software/make";
      license = licenses.gpl3Plus;
      maintainers = teams.minimal-bootstrap.members;
      mainProgram = "make";
      platforms = platforms.unix;
    };
  }
  ''
    # Unpack
    tar xzf ${src}
    cd make-${version}

    # Patch
    ${lib.concatMapStringsSep "\n" (f: "patch -Np1 -i ${f}") patches}

    # Configure
    export CC="tcc -B ${tinycc.libs}/lib"
    export LD=tcc
    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config}

    # Build
    make AR="tcc -ar"

    # Install
    make install
  ''
