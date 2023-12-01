{ lib, stdenv, fetchgit, autoreconfHook, pkg-config, cmocka, acl, libuuid, lzo, zlib, zstd }:

stdenv.mkDerivation rec {
  pname = "mtd-utils";
  version = "2.1.6";

  src = fetchgit {
    url = "git://git.infradead.org/mtd-utils.git";
    rev = "v${version}";
    sha256 = "sha256-NMYzUPt/91lv8f7E1ytX91SqwbBEOtHjCL54EcumcZA=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ] ++ lib.optional doCheck cmocka;
  buildInputs = [ acl libuuid lzo zlib zstd ];

  enableParallelBuilding = true;

  configureFlags = with lib; [
    (enableFeature doCheck "unit-tests")
    (enableFeature doCheck "tests")
  ];

  makeFlags = [
    "AR:=$(AR)"
  ];

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  outputs = [ "out" "dev" ];

  postInstall = ''
    mkdir -p $dev/lib
    mv *.a $dev/lib/
    mv include $dev/
  '';

  meta = with lib; {
    description = "Tools for MTD filesystems";
    downloadPage = "https://git.infradead.org/mtd-utils.git";
    license = licenses.gpl2Plus;
    homepage = "http://www.linux-mtd.infradead.org/";
    maintainers = with maintainers; [ viric ];
    platforms = with platforms; linux;
  };
}
