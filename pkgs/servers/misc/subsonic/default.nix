{ stdenv, fetchurl, jre }:

let version = "5.2.1"; in

stdenv.mkDerivation rec {
  name = "subsonic-${version}";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/subsonic/subsonic-${version}-standalone.tar.gz";
    sha256 = "523fa8357c961c1ae742a15f0ceaabdd41fcba9137c29d244957922af90ee791";
  };

  inherit jre;

  # Create temporary directory to extract tarball into to satisfy Nix's need
  # for a directory to be created in the unpack phase.
  unpackPhase = ''
    mkdir ${name}
    tar -C ${name} -xzf $src
  '';
  installPhase = ''
    mkdir $out
    cp -r ${name}/* $out
  '';

  meta = {
    homepage = http://subsonic.org;
    description = "Personal media streamer";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ telotortium ];
  };

  phases = ["unpackPhase" "installPhase"];
}
