{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bash
, gcc
, glibc
, binutils
, linux-headers
, gnumake
, gnugrep
, gnused
, gawk
, gnutar
, gzip
}:
let
  pname = "diffutils";
  version = "2.8.1";

  src = fetchurl {
    url = "mirror://gnu/diffutils/diffutils-${version}.tar.gz";
    sha256 = "0nizs9r76aiymzasmj1jngl7s71jfzl9xfziigcls8k9n141f065";
  };
in
bash.runCommand "${pname}-${version}" {
  inherit pname version;

  nativeBuildInputs = [
    gcc
    binutils
    gnumake
    gnused
    gnugrep
    gawk
    gnutar
    gzip
  ];

  passthru.tests.get-version = result:
    bash.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/diff --version
      mkdir $out
    '';

  meta = with lib; {
    description = "Commands for showing the differences between files (diff, cmp, etc.)";
    homepage = "https://www.gnu.org/software/diffutils/diffutils.html";
    license = licenses.gpl3Only;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
} ''
  # Unpack
  tar xzf ${src}
  cd diffutils-${version}

  # Configure
  export C_INCLUDE_PATH="${glibc}/include:${linux-headers}/include"
  export LIBRARY_PATH="${glibc}/lib"
  export LIBS="-lc -lnss_files -lnss_dns -lresolv"
  bash ./configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config}

  # Build
  make

  # Install
  make install
''
