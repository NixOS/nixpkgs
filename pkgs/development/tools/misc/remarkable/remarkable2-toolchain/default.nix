{ lib, stdenv, fetchurl, libarchive, python3, file }:

stdenv.mkDerivation rec {
  pname = "remarkable2-toolchain";
  version = "2.5.2";

  src = fetchurl {
    url = "https://storage.googleapis.com/codex-public-bucket/codex-x86_64-cortexa7hf-neon-rm11x-toolchain-${version}.sh";
    sha256 = "1v410q1jn8flisdpkrymxd4pa1ylawd0rh3rljjpkqw1bp8a5vw1";
  };

  nativeBuildInputs = [
    libarchive
    python3
    file
  ];

  unpackCmd = ''
    mkdir src
    install $curSrc src/install-toolchain.sh
  '';

  dontBuild = true;

  installPhase = ''
    patchShebangs install-toolchain.sh
    sed -i -e '3,9d' install-toolchain.sh # breaks PATH
    sed -i 's|PYTHON=.*$|PYTHON=${python3}/bin/python|' install-toolchain.sh
    ./install-toolchain.sh -D -y -d $out
  '';

  meta = with lib; {
    description = "A toolchain for cross-compiling to reMarkable 2 tablets";
    homepage = "https://remarkable.engineering/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ tadfisher ];
    platforms = platforms.x86_64;
  };
}
