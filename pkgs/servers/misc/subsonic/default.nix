{ stdenv, fetchurl, jre }:

let version = "6.0"; in

stdenv.mkDerivation rec {
  name = "subsonic-${version}";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/subsonic/subsonic-${version}-standalone.tar.gz";
    sha256 = "0aw7lz7bkhqvjj3lkk68n2aqr5l84s91cgifg2379w2j7dgd056z";
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
