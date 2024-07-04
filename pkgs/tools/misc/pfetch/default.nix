{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "pfetch";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "pfetch";
    rev = version;
    sha256 = "06z0k1naw3k052p2z7241lx92rp5m07zlr0alx8pdm6mkc3c4v8f";
  };

  dontBuild = true;

  installPhase = ''
    install -Dm755 -t $out/bin pfetch
  '';

  meta = with lib; {
    description = "Pretty system information tool written in POSIX sh";
    homepage = "https://github.com/dylanaraps/pfetch";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ equirosa ];
    mainProgram = "pfetch";
  };
}
