{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "check-uptime-${version}";
  version = "20161112";

  src = fetchFromGitHub {
    owner  = "madrisan";
    repo   = "nagios-plugins-uptime";
    rev    = "51822dacd1d404b3eabf3b4984c64b2475ed6f3b";
    sha256 = "18q9ibzqn97dsyr9xs3w9mqk80nmmfw3kcjidrdsj542amlsycyk";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  postInstall = "ln -sr $out/libexec $out/bin";

  meta = with stdenv.lib; {
    description = "Uptime check plugin for Sensu/Nagios/others";
    homepage    = https://github.com/madrisan/nagios-plugins-uptime;
    license     = licenses.gpl3;
    maintainer  = with maintainers; [ peterhoeg ];
  };
}
