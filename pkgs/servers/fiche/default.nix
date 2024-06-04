{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "fiche";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "solusipse";
    repo = "fiche";
    rev = version;
    sha256 = "1102r39xw17kip7mjp987jy8na333gw9vxv31f7v8q05cr7d7kfb";
  };

  installPhase = ''
    install -Dm755 fiche -t $out/bin
  '';

  doCheck = true;

  meta = with lib; {
    description = "Command line pastebin for sharing terminal output";
    longDescription = ''
      Fiche is a command line pastebin server for sharing terminal output.
      It can be used without any graphical tools from a TTY and has minimal requirements.
      A live instance can be found at https://termbin.com.

      Example usage:
      echo just testing! | nc termbin.com 9999
    '';

    homepage = "https://github.com/solusipse/fiche";
    changelog = "https://github.com/solusipse/fiche/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ maintainers.pinpox ];
    platforms = platforms.all;
    mainProgram = "fiche";
  };
}
