{ stdenv, fetchurl, autoPatchelfHook
, ncurses5
}:

stdenv.mkDerivation rec {
  name = "adom-${version}";
  version = "3.3.3";

  src = fetchurl {
    url = "https://www.adom.de/home/download/current/adom_linux_ubuntu_64_${version}.tar.gz";
    sha256 = "493ef76594c1f6a7f38dcf32a76cd107fb71dd12bf917c18fdeaebcac1a353b1";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ ncurses5 ];

  installPhase = ''
    mkdir -p $out/bin $out/share
    cp -a adom $out/bin
    cp -a docs licenses $out/share
  '';

  meta = with stdenv.lib; {
    description = "A rogue-like game with nice graphical interface";
    homepage = http://adom.de/;
    license = licenses.unfreeRedistributable;
    maintainers = [maintainers.Baughn];

    # Please, notify me (Baughn) if you need the x86 version
    platforms = ["x86_64-linux"];
  };
}
