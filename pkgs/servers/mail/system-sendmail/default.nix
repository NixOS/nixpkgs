{
  lib,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "system-sendmail";
  version = "1.0";

  src = ./sendmail.c;

  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = true;

  buildPhase = ''
    runHook preBuild
    $CC -O2 -Wall -Wextra -DPATH_SELF="\"$out/bin/sendmail\"" -o sendmail "$src"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 sendmail $out/bin/sendmail
    runHook postInstall
  '';

  meta = {
    description = ''
      A sendmail wrapper that calls the system sendmail. Do not install as system-wide sendmail!
    '';
    platforms = lib.platforms.unix;
    mainProgram = "sendmail";
  };
}
