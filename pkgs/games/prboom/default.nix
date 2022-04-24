{ lib, stdenv, fetchurl, SDL, SDL_mixer, SDL_net
, libGLU ? null
, libGL ? null
, useOpenGL ? stdenv.hostPlatform == stdenv.buildPlatform
}:

assert useOpenGL -> libGL != null && libGLU != null;

stdenv.mkDerivation rec {
  pname = "prboom";
  version = "2.5.0";
  src = fetchurl {
    url = "mirror://sourceforge/prboom/prboom-${version}.tar.gz";
    sha256 = "1bjb04q8dk232956k30qlpq6q0hxb904yh1nflr87jcc1x3iqv12";
  };

  buildInputs = [ SDL SDL_mixer SDL_net ]
    ++ lib.optionals useOpenGL [ libGL libGLU ];

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  configureFlags = [
    (lib.enableFeature useOpenGL "gl")
    (lib.enableFeature doCheck "sdltest")
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--disable-cpu-opt"
    "--without-x"
    "ac_cv_type_uid_t=yes"
    "ac_cv_type_gid_t=yes"
  ];

  postInstall = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    mv $out/games/ $out/bin
  '';
}
