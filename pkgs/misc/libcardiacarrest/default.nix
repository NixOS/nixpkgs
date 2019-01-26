{ stdenv, fetchFromGitHub, pkgconfig, glib, libpulseaudio }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libcardiacarrest-${version}";
  version = "12.1-7"; # <PA API version>-<version>

  src = fetchFromGitHub {
    owner = "oxij";
    repo = "libcardiacarrest";
    rev = "d44288d9a24d6b7793fb36a4c9a548b6b55375ec";
    sha256 = "0j3l5s6r9hgpy5y7q7kx0rkh05rk0bgfdvzbmadqps720lqjs4xm";
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
