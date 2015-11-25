{ stdenv, fetchurl, jre }:

let version = "5.3"; in

stdenv.mkDerivation rec {
  name = "subsonic-${version}";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/subsonic/subsonic-${version}-standalone.tar.gz";
    sha256 = "11ylg89r9dbxyas7jcyij6fpm84dixskdkahb3hdi4ig0wqwswfw";
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
