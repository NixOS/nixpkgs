{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pfetch";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "pfetch";
    rev = version;
    sha256 = "180vvbmvak888vs4dgzlmqk0ss4qfsz09700n4p8s68j7krkxsfq";
  };

  dontbuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp pfetch $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A pretty system information tool written in POSIX sh";
    homepage = https://github.com/dylanaraps/pfetch;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ equirosa ];
  };
}
