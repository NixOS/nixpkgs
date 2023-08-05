{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bash
, gnumake
, mesBootstrap ? false, tinycc ? null
, gcc ? null, glibc ? null, binutils ? null, gnused ? null, linux-headers, gnugrep
}:
assert mesBootstrap -> tinycc != null;
assert !mesBootstrap -> gcc != null && glibc != null && binutils != null && gnused != null;
let
  pname = "gnused" + lib.optionalString mesBootstrap "-mes";
  # last version that can be compiled with mes-libc
  version = "4.0.9";

  src = fetchurl {
    url = "mirror://gnu/sed/sed-${version}.tar.gz";
    sha256 = "0006gk1dw2582xsvgx6y6rzs9zw8b36rhafjwm288zqqji3qfrf3";
  };

  # Thanks to the live-bootstrap project!
  # See https://github.com/fosslinux/live-bootstrap/blob/1bc4296091c51f53a5598050c8956d16e945b0f5/sysa/sed-4.0.9/sed-4.0.9.kaem
  makefile = fetchurl {
    url = "https://github.com/fosslinux/live-bootstrap/raw/1bc4296091c51f53a5598050c8956d16e945b0f5/sysa/sed-4.0.9/mk/main.mk";
    sha256 = "0w1f5ri0g5zla31m6l6xyzbqwdvandqfnzrsw90dd6ak126w3mya";
  };
in
bash.runCommand "${pname}-${version}" {
  inherit pname version;

  nativeBuildInputs = [
    gnumake
  ] ++ lib.optionals mesBootstrap [
    tinycc.compiler
  ] ++ lib.optionals (!mesBootstrap) [
    gcc
    glibc
    binutils
    gnused
    gnugrep
  ];

  passthru.tests.get-version = result:
    bash.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/sed --version
      mkdir ''${out}
    '';

  meta = with lib; {
    description = "GNU sed, a batch stream editor";
    homepage = "https://www.gnu.org/software/sed";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    mainProgram = "sed";
    platforms = platforms.unix;
  };
} (''
  # Unpack
  ungz --file ${src} --output sed.tar
  untar --file sed.tar
  rm sed.tar
  cd sed-${version}

'' + lib.optionalString mesBootstrap ''
  # Configure
  cp ${makefile} Makefile
  catm config.h

  # Build
  make \
    CC="tcc -B ${tinycc.libs}/lib" \
    LIBC=mes

'' + lib.optionalString (!mesBootstrap) ''
  # Configure
  export CC="gcc -I${glibc}/include -I${linux-headers}/include"
  export LIBRARY_PATH="${glibc}/lib"
  export LIBS="-lc -lnss_files -lnss_dns -lresolv"
  chmod +x configure
  ./configure \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config} \
    --disable-shared \
    --disable-nls \
    --disable-dependency-tracking \
    --without-included-regex \
    --prefix=$out

  # Build
  make

'' + ''
  # Install
  make install PREFIX=$out
'')
