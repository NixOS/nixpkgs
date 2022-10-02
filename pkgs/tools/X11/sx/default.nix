{ lib
, bash
, coreutils
, fetchFromGitHub
, resholve
, xauth
, xorgserver
}:

resholve.mkDerivation rec {
  pname = "sx";
  version = "2.1.7";

  src = fetchFromGitHub {
    owner = "earnestly";
    repo = pname;
    rev = version;
    sha256 = "0xv15m30nhcknasqiybj5wwf7l91q4a4jf6xind8x5x00c6br6nl";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  solutions = {
    sx = {
      scripts = [ "bin/sx" ];
      interpreter = "${bash}/bin/sh";
      inputs = [
        coreutils
        xauth
        xorgserver
      ];
      execer = [
        "cannot:${xorgserver}/bin/Xorg"
      ];
    };
  };

  meta = with lib; {
    description = "Simple alternative to both xinit and startx for starting a Xorg server";
    homepage = "https://github.com/earnestly/sx";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ figsoda thiagokokada ];
  };
}
