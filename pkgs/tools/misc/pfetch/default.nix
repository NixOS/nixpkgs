{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "pfetch";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "pfetch";
    rev = version;
    sha256 = "180vvbmvak888vs4dgzlmqk0ss4qfsz09700n4p8s68j7krkxsfq";
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
