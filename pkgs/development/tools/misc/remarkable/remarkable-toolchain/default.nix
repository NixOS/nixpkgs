{
  lib,
  stdenv,
  fetchurl,
  libarchive,
  python3,
  file,
  which,
}:

stdenv.mkDerivation rec {
  pname = "remarkable-toolchain";
  version = "3.1.2";

  src = fetchurl {
    url = "https://storage.googleapis.com/remarkable-codex-toolchain/codex-x86_64-cortexa9hf-neon-rm10x-toolchain-${version}.sh";
    sha256 = "sha256-ocODUUx2pgmqxMk8J+D+OvqlSHBSay6YzcqnxC9n59w=";
    executable = true;
  };

  nativeBuildInputs = [
    libarchive
    python3
    file
    which
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    ENVCLEANED=1 $src -y -d $out
  '';

  meta = with lib; {
    description = "A toolchain for cross-compiling to reMarkable tablets";
    homepage = "https://remarkable.engineering/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      nickhu
      siraben
    ];
    platforms = [ "x86_64-linux" ];
  };
}
