{
  lib,
  fetchurl,
  bash,
  tinycc,
  gnumake,
  gnused,
  gnugrep,
}:
let
  pname = "gzip";
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://gnu/gzip/gzip-${version}.tar.gz";
    sha256 = "0ryr5b00qz3xcdcv03qwjdfji8pasp0007ay3ppmk71wl8c1i90w";
  };
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version;

    nativeBuildInputs = [
      tinycc.compiler
      gnumake
      gnused
      gnugrep
    ];

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/gzip --version
        mkdir $out
      '';

    meta = with lib; {
      description = "GNU zip compression program";
      homepage = "https://www.gnu.org/software/gzip";
      license = licenses.gpl3Plus;
      maintainers = teams.minimal-bootstrap.members;
      platforms = platforms.unix;
    };
  }
  ''
    # Unpack
    ungz --file ${src} --output gzip.tar
    untar --file gzip.tar
    rm gzip.tar
    cd gzip-${version}

    # Configure
    export CC="tcc -B ${tinycc.libs}/lib -Dstrlwr=unused"
    bash ./configure --prefix=$out

    # Build
    make

    # Install
    mkdir $out
    make install
  ''
