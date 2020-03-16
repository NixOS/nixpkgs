{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "pfetch";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "pfetch";
    rev = version;
    sha256 = "0yg9nlrjnm2404ysm2qp1klpq1wlmyih302kzfqchn6l2sibsm4j";
  };

  dontBuild = true;

  installPhase = ''
    install -Dm755 -t $out/bin pfetch
  '';

  meta = with lib; {
    description = "A pretty system information tool written in POSIX sh";
    homepage = https://github.com/dylanaraps/pfetch;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ equirosa ];
  };
}
