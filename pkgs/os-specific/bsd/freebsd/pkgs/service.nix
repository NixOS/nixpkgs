{
  lib,
  mkDerivation,
  env,
}:
mkDerivation {
  path = "usr.sbin/service";
  postPatch = ''
    substituteInPlace usr.sbin/service/service.sh --replace-fail /usr/bin/env ${lib.getExe env}
  '';
}
