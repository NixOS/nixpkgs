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
, xz
}:
let
  pname = "diffutils";
  # last version that can be built by tinycc-musl 0.9.27
  version = "3.8";

  src = fetchurl {
    url = "mirror://gnu/diffutils/diffutils-${version}.tar.xz";
    hash = "sha256-pr3X0bMSZtEcT03mwbdI1GB6sCMa9RiPwlM9CuJDj+w=";
  };
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
    xz
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
  cp ${src} diffutils.tar.xz
  unxz diffutils.tar.xz
  tar xf diffutils.tar
  rm diffutils.tar
  cd diffutils-${version}

  # Configure
  export CC="tcc -B ${tinycc.libs}/lib"
  export LD=tcc
  bash ./configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config}

  # Build
  make -j $NIX_BUILD_CORES AR="tcc -ar"

  # Install
  make -j $NIX_BUILD_CORES install
''
