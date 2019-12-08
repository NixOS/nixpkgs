{ stdenv, fetchurl, SDL, SDL_mixer, SDL_net
, libGLU ? null
, libGL ? null
, useOpenGL ? stdenv.hostPlatform == stdenv.buildPlatform
}:

assert useOpenGL -> libGL != null && libGLU != null;

stdenv.mkDerivation rec {
  name = "prboom-2.5.0";
  src = fetchurl {
    url = mirror://sourceforge/prboom/prboom-2.5.0.tar.gz;
    sha256 = "1bjb04q8dk232956k30qlpq6q0hxb904yh1nflr87jcc1x3iqv12";
  };

  buildInputs = [ SDL SDL_mixer SDL_net ]
    ++ stdenv.lib.optionals useOpenGL [ libGL libGLU ];

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  configureFlags = [
    (stdenv.lib.enableFeature useOpenGL "gl")
    (stdenv.lib.enableFeature doCheck "sdltest")
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--disable-cpu-opt"
    "--without-x"
    "ac_cv_type_uid_t=yes"
    "ac_cv_type_gid_t=yes"
  ];

  postInstall = stdenv.lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    mv $out/games/ $out/bin
  '';
}
