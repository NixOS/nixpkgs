{ lib, fetchurl, python3Packages, fetchpatch }:

python3Packages.buildPythonApplication rec {
  pname = "iotop";
  version = "0.6";

  src = fetchurl {
    url = "http://guichaz.free.fr/iotop/files/iotop-${version}.tar.bz2";
    sha256 = "0nzprs6zqax0cwq8h7hnszdl3d2m4c2d4vjfxfxbnjfs9sia5pis";
  };

  patches = [
    (fetchpatch {
      url = "https://repo.or.cz/iotop.git/patch/99c8d7cedce81f17b851954d94bfa73787300599";
      sha256 = "0rdgz6xpmbx77lkr1ixklliy1aavdsjmfdqvzwrjylbv0xh5wc8z";
    })
  ];

  doCheck = false;

  meta = with lib; {
    description = "Tool to find out the processes doing the most IO";
    homepage = "http://guichaz.free.fr/iotop";
    license = licenses.gpl2;
    mainProgram = "iotop";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
