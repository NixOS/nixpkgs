{ stdenv, fetchurl, pkgName, sha256, version
, buildInputs ? [], propagatedBuildInputs ? []
}:

stdenv.mkDerivation rec {
  name = "alsa-${pkgName}-${version}";

  src = fetchurl {
    url = "ftp://ftp.alsa-project.org/pub/${pkgName}/${name}.tar.bz2";
    inherit sha256;
  };

  inherit buildInputs propagatedBuildInputs;

  configureFlags = "--disable-xmlto";

  meta = {
    description = "ALSA, the Advanced Linux Sound Architecture (${pkgName})";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    homepage = http://www.alsa-project.org/;
  };
}
