{ lib, stdenv, fetchgit, autoreconfHook, pkg-config, cmocka, acl, libuuid, lzo, zlib, zstd }:

stdenv.mkDerivation rec {
  pname = "mtd-utils";
  version = "2.1.5";

  src = fetchgit {
    url = "git://git.infradead.org/mtd-utils.git";
    rev = "v${version}";
    sha256 = "sha256-Ph9Xjb2Nyo7l3T1pDgW2gnSJxn0pOC6uvCGUfCh0MXU=";
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
    downloadPage = "https://git.infradead.org/mtd-utils.git";
    license = licenses.gpl2Plus;
    homepage = "http://www.linux-mtd.infradead.org/";
    maintainers = with maintainers; [ viric ];
    platforms = with platforms; linux;
  };
}
