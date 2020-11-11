{ lib, stdenv, fetchFromGitHub, ncurses, coreutils }:

stdenv.mkDerivation rec {
  pname = "wit";
  version = "3.0.3b";

  src = fetchFromGitHub {
    owner = "Wiimm";
    repo = "wiimms-iso-tools";
    rev = "7f41a7f1edf2bd1698482cafe1b10f6b87b73da7";
    sha256 = "1vhsi87vwjnmvnwjw8gnqqh9wishzcx885kwxm5j51zizl1mhqi9";
  };

  hardeningDisable = [ "format" ];
  buildInputs = [ ncurses ];

  postUnpack = ''
    sourceRoot=''${sourceRoot}/project
  '';

  postPatch = ''
    sed -ie 's|/usr/bin/env|${coreutils}/bin/env|' gen-template.sh
    sed -ie 's|/usr/bin/env|${coreutils}/bin/env|' gen-text-file.sh
  '';

  installPhase = ''
    install -Dm755 bin/wit bin/wdf bin/wtest bin/wwt -t $out/bin
  '';

  meta = with lib; {
    description =
      "Command line tools to extract, modify, and create Wii and GameCube ISO images and WBFS containers.";
    homepage = "https://wit.wiimm.de/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ djanatyn ];
  };
}
