{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "subsonic-${version}";
  version = "6.1.5";

  src = fetchurl {
    url = "mirror://sourceforge/subsonic/subsonic-${version}-standalone.tar.gz";
    sha256 = "1xz3flxd5hxcvvg1izzxpv5rxwb5zprk92vsgvmcniy7j7r66936";
  };

  inherit jre;

  # Create temporary directory to extract tarball into to satisfy Nix's need
  # for a directory to be created in the unpack phase.
  unpackPhase = ''
    runHook preUnpack
    mkdir ${name}
    tar -C ${name} -xzf $src
    runHook postUnpack
  '';
  installPhase = ''
    runHook preInstall
    mkdir $out
    cp -r ${name}/* $out
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = http://subsonic.org;
    description = "Personal media streamer";
    license = licenses.unfree;
    maintainers = with maintainers; [ telotortium ];
    platforms = platforms.unix;
  };

  phases = ["unpackPhase" "installPhase"];
}
