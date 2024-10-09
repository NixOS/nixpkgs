{ lib, stdenv, fetchurl, cmake, python3, bison, openssl, readline, bzip2, nixosTests }:

stdenv.mkDerivation (finalAttrs: {
  pname = "monetdb";
  version = "11.49.11";

  src = fetchurl {
    url = "https://dev.monetdb.org/downloads/sources/archive/MonetDB-${finalAttrs.version}.tar.bz2";
    hash = "sha256-tnGRNTx/SH7Yj8xvaFUxKr8af+7b8ZouU4PdmKEMkKk=";
  };

  nativeBuildInputs = [ bison cmake python3 ];
  buildInputs = [ openssl readline bzip2 ];

  postPatch = ''
    substituteInPlace cmake/monetdb-packages.cmake --replace \
      'get_os_release_info(LINUX_DISTRO LINUX_DISTRO_VERSION)' \
      'set(LINUX_DISTRO "nixos")'
  '';

  postInstall = ''
    rm $out/bin/monetdb_mtest.sh \
      $out/bin/mktest.py \
      $out/bin/sqlsample.php \
      $out/bin/sqllogictest.py \
      $out/bin/Mz.py \
      $out/bin/Mtest.py \
      $out/bin/sqlsample.pl \
      $out/bin/malsample.pl \
      $out/bin/Mconvert.py
  '';

  passthru.tests = { inherit (nixosTests) monetdb; };

  meta = with lib; {
    description = "Open source database system";
    homepage = "https://www.monetdb.org/";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.StillerHarpo ];
  };
})
