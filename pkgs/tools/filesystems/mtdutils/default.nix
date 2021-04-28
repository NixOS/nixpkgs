{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, cmocka, acl, libuuid, lzo, zlib, zstd }:

stdenv.mkDerivation rec {
  pname = "mtd-utils";
  version = "2.1.2";

  src = fetchurl {
    url = "ftp://ftp.infradead.org/pub/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-itTF80cW1AZGqihySi9WFtMlpvEZJU+RTiaXbx926dY=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ] ++ lib.optional doCheck cmocka;
  buildInputs = [ acl libuuid lzo zlib zstd ];

  configureFlags = with lib; [
    (enableFeature doCheck "unit-tests")
    (enableFeature doCheck "tests")
  ];

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  meta = with lib; {
    description = "Tools for MTD filesystems";
    license = licenses.gpl2Plus;
    homepage = "http://www.linux-mtd.infradead.org/";
    maintainers = with maintainers; [ viric superherointj ];
    platforms = with platforms; linux;
  };
}
