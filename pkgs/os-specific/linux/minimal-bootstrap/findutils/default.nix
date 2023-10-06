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
  pname = "findutils";
  version = "4.4.2";

  src = fetchurl {
    url = "mirror://gnu/findutils/findutils-${version}.tar.gz";
    sha256 = "0amn0bbwqvsvvsh6drfwz20ydc2czk374lzw5kksbh6bf78k4ks3";
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
      ${result}/bin/find --version
      mkdir $out
    '';

  meta = with lib; {
    description = "GNU Find Utilities, the basic directory searching utilities of the GNU operating system";
    homepage = "https://www.gnu.org/software/findutils";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
} ''
  # Unpack
  tar xzf ${src}
  cd findutils-${version}

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
