{ stdenv, fetchurl, jre }:

let version = "6.1.3"; in

stdenv.mkDerivation rec {
  name = "subsonic-${version}";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/subsonic/subsonic-${version}-standalone.tar.gz";
    sha256 = "1v21gfymaqcx6n6d88hvha60q9hgj5z1wsac5gcwq7cjah1893jx";
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
    platforms = with stdenv.lib.platforms; unix;
  };

  phases = ["unpackPhase" "installPhase"];
}
