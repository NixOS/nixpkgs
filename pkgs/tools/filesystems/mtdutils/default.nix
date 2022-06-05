{ lib, stdenv, fetchgit, autoreconfHook, pkg-config, cmocka, acl, libuuid, lzo, zlib, zstd }:

stdenv.mkDerivation rec {
  pname = "mtd-utils";
  version = "2.1.4";

  src = fetchgit {
    url = "git://git.infradead.org/mtd-utils.git";
    rev = "v${version}";
    sha256 = "sha256-lnvG2aJiihOyScmWZu0i8OYowmIMRBkgC3j67sdLkT4=";
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
