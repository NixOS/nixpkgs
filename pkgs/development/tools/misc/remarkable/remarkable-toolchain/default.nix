{ stdenv, fetchurl, libarchive, python3, file }:

stdenv.mkDerivation rec {
  pname = "remarkable-toolchain";
  version = "1.8-23.9.2019";

  src = fetchurl {
    url = "https://remarkable.engineering/oecore-x86_64-cortexa9hf-neon-toolchain-zero-gravitas-${version}.sh";
    sha256 = "6299955721bcd9bef92a87ad3cfe4d31df8e2da95b0c4b2cdded4431aa6748b0";
  };

  nativeBuildInputs = [
    libarchive
    python3
    file
  ];

  unpackCmd = "mkdir src; install $curSrc src/install-toolchain.sh";

  dontBuild = true;

  installPhase = ''
    patchShebangs install-toolchain.sh
    sed -i -e '3,9d' install-toolchain.sh # breaks PATH
    sed -i 's|PYTHON=.*$|PYTHON=${python3}/bin/python|' install-toolchain.sh
    ./install-toolchain.sh -D -y -d $out
  '';

  meta = with stdenv.lib; {
    description = "A toolchain for cross-compiling to reMarkable tablets";
    homepage = "https://remarkable.engineering/";
    license = licenses.gpl2;
    maintainers = [ maintainers.nickhu ];
    platforms = platforms.x86_64;
  };
}
