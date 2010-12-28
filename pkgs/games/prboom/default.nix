{stdenv, fetchurl, SDL, SDL_mixer, SDL_net, mesa}:

stdenv.mkDerivation {
  name = "prboom-2.5.0";
  src = fetchurl {
    url = mirror://sourceforge/prboom/prboom-2.5.0.tar.gz;
    sha256 = "1bjb04q8dk232956k30qlpq6q0hxb904yh1nflr87jcc1x3iqv12";
  };

  buildInputs = [ SDL SDL_mixer SDL_net mesa ];
  crossAttrs = {
    propagatedBuildInputs = [ SDL.hostDrv SDL_mixer.hostDrv SDL_net.hostDrv ];
    configureFlags = "--disable-gl --disable-cpu-opt --without-x --disable-sdltest
      ac_cv_type_uid_t=yes ac_cv_type_gid_t=yes";

    postInstall = ''
      mv $out/games/ $out/bin
    '';
  };
}
