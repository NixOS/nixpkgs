{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  makeWrapper,
  php83,
  icingaweb2-ipl,
  icingaweb2-thirdparty,
  nixosTests,
}:

stdenvNoCC.mkDerivation rec {
  pname = "icingaweb2";
  version = "2.12.6";

  src = fetchFromGitHub {
    owner = "Icinga";
    repo = "icingaweb2";
    rev = "v${version}";
    hash = "sha256-iKxvrZcwzUoh+TVsmx8jVjwHeklT1+dqzhY4kBbOB8Q=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/icinga-php
    cp -ra application bin etc library modules public schema $out
    cp -ra doc $out/share

    ln -s ${icingaweb2-ipl} $out/share/icinga-php/ipl
    ln -s ${icingaweb2-thirdparty} $out/share/icinga-php/vendor

    wrapProgram $out/bin/icingacli --prefix PATH : "${lib.makeBinPath [ php83 ]}" --suffix ICINGAWEB_LIBDIR : $out/share/icinga-php
  '';

  passthru.tests = { inherit (nixosTests) icingaweb2; };

  meta = {
    description = "Webinterface for Icinga 2";
    longDescription = ''
      A lightweight and extensible web interface to keep an eye on your environment.
      Analyse problems and act on them.
    '';
    homepage = "https://www.icinga.com/products/icinga-web-2/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      das_j
      helsinki-Jo
    ];
    mainProgram = "icingacli";
    platforms = lib.platforms.all;
  };
}
