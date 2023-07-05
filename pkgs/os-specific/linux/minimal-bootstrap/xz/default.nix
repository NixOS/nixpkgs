{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bash
, tinycc
, gnumake
, gnugrep
, gawk
, sed
}:
let
  pname = "xz";
  # >=5.2 uses poll.h, unsupported by meslibc
  version = "5.0.8";

  src = fetchurl {
    url = "https://tukaani.org/xz/xz-${version}.tar.bz2";
    sha256 = "1nkb68dyrf16xwyqichcy1vhgbfg20dxz459rcsdx85h1gczk1i2";
  };
in
bash.runCommand "${pname}-${version}" {
  inherit pname version;

  nativeBuildInputs = [
    tinycc.compiler
    gnumake
    gnugrep
    gawk
    sed
  ];

  passthru.tests.get-version = result:
    bash.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/xz --version
      mkdir $out
    '';

  meta = with lib; {
    description = "A general-purpose data compression software, successor of LZMA";
    homepage = "https://tukaani.org/xz";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
} ''
  # Unpack
  unbz2 --file ${src} --output xz.tar
  untar --file xz.tar
  rm xz.tar
  cd xz-${version}

  # Configure
  export CC="tcc -B ${tinycc.libs}/lib -include${./stubs.h}"
  export CPP="tcc -E"
  export LD=tcc
  export AR="tcc -ar"
  export SED=sed
  export ac_cv_prog_cc_c99=
  export ac_cv_header_fcntl_h=yes
  export ac_cv_header_limits_h=yes
  export ac_cv_header_sys_time_h=yes
  export ac_cv_func_utime=no
  bash ./configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config} \
    --disable-shared \
    --disable-nls \
    --disable-threads \
    --disable-assembler

  # Build
  make all

  # Install
  make install
''
