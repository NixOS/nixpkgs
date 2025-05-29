{
  autoreconfHook,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "check-uptime";
  version = "0-unstable-2016-11-12";

  src = fetchFromGitHub {
    owner = "madrisan";
    repo = "nagios-plugins-uptime";
    rev = "51822dacd1d404b3eabf3b4984c64b2475ed6f3b";
    hash = "sha256-0zOvaVWCFKlbblGyObir1QI0cU186J6y1+0ki/+KCaM=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  postInstall = ''
    ln -sr $out/libexec $out/bin
  '';

  meta = {
    description = "Uptime check plugin for Sensu/Nagios/others";
    homepage = "https://github.com/madrisan/nagios-plugins-uptime";
    license = lib.licenses.gpl3Plus;
    mainProgram = "check_uptime";
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
