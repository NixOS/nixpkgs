{ stdenv, fetchFromGitHub, pkgconfig, glib, libpulseaudio }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libcardiacarrest-${version}";
  version = "12.2.8"; # <PA API version>.<version>

  src = fetchFromGitHub {
    owner = "oxij";
    repo = "libcardiacarrest";
    rev = "d89639f5b2d298cf74af26880f5ebf50e645166d";
    sha256 = "0vrigwcw3g8zknqyznv6y3437ahn1w00gv3d303smmygr0p8bd94";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ glib ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    moveToOutput $out/include $dev
    moveToOutput $out/lib/pkgconfig $dev
    moveToOutput $out/lib/cmake $dev
  '';

  meta = src.meta // {
    description = "A trivial implementation of libpulse PulseAudio library API";
    longDescription = ''
      libcardiacarrest is a trivial implementation of libpulse
      PulseAudio library API that unconditionally (but gracefully)
      fails to connect to the PulseAudio daemon and does nothing else.

      apulse and pressureaudio (which uses apulse internally) are an
      inspiration for this but unlike those two projects
      libcardiacarrest is not an emulation layer, all it does is it
      gracefully fails to provide the requested PulseAudio service
      hoping the application would try something else (e.g. ALSA or
      JACK).
    '';
    license = libpulseaudio.meta.license; # "same as PA headers"
    maintainers = [ maintainers.oxij ]; # also the author
  };

}
