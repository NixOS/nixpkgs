{aName, sha256, buildInputs ? [], propagatedBuildInputs ? [] } :
args: with args; stdenv.mkDerivation rec {
  name = "alsa-" + aName + "-" + version;

  src = fetchurl {
    url = "ftp://ftp.alsa-project.org/pub/" + aName + "/" + name + ".tar.bz2";
    inherit sha256;
  };

  inherit buildInputs propagatedBuildInputs;

  meta = {
    description = "ALSA, the Advanced Linux Sound Architecture (${aName})";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    homepage = http://www.alsa-project.org/;
  };
}
