{
  autoreconfHook,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "check_uptime";
  version = "20161112";

  src = fetchFromGitHub {
    owner = "madrisan";
    repo = "nagios-plugins-uptime";
    rev = "51822dacd1d404b3eabf3b4984c64b2475ed6f3b";
    sha256 = "18q9ibzqn97dsyr9xs3w9mqk80nmmfw3kcjidrdsj542amlsycyk";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  postInstall = "ln -sr $out/libexec $out/bin";

  meta = {
    description = "Uptime check plugin for Sensu/Nagios/others";
    homepage = "https://github.com/madrisan/nagios-plugins-uptime";
    license = lib.licenses.gpl3;
    mainProgram = "check_uptime";
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
