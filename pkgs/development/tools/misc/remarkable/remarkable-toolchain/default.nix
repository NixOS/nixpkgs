{ stdenv, fetchurl, libarchive, python, file, which }:

stdenv.mkDerivation rec {
  pname = "remarkable-toolchain";
  version = "1.8-23.9.2019";

  src = fetchurl {
    url = "https://remarkable.engineering/oecore-x86_64-cortexa9hf-neon-toolchain-zero-gravitas-${version}.sh";
    sha256 = "1rk1r80m5d18sw6hrybj6f78s8pna0wrsa40ax6j8jzfwahgzmfb";
    executable = true;
  };

  nativeBuildInputs = [
    libarchive
    python
    file
    which
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    ENVCLEANED=1 $src -y -d $out
  '';

  meta = with stdenv.lib; {
    description = "A toolchain for cross-compiling to reMarkable tablets";
    homepage = "https://remarkable.engineering/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ nickhu siraben ];
    platforms = [ "x86_64-linux" ];
  };
}
