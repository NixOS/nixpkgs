{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, alsaLib, icu }:

stdenv.mkDerivation rec {
  name = "mycroft-mimic-${version}";
  version = "1.2.0.2";

  src = fetchFromGitHub {
    owner  = "mycroftai";
    repo   = "mimic";
    rev    = version;
    sha256 = "1wkpbwk88lsahzkc7pzbznmyy0lc02vsp0vkj8f1ags1gh0lc52j";
  };

  buildInputs = [ alsaLib icu ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Mycroft's TTS engine, based on CMU's Flite (Festival Lite)";
    homepage = https://mimic.mycroft.ai;
  };
}
