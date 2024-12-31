{ lib, stdenv, fetchFromGitHub, btrfs-progs }:

stdenv.mkDerivation rec {
  pname = "compsize";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "kilobyte";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OX41ChtHX36lVRL7O2gH21Dfw6GPPEClD+yafR/PFm8=";
  };

  buildInputs = [ btrfs-progs ];

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  preInstall = ''
    mkdir -p $out/share/man/man8
  '';

  meta = with lib; {
    description = "btrfs: Find compression type/ratio on a file or set of files";
    mainProgram = "compsize";
    homepage = "https://github.com/kilobyte/compsize";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ CrazedProgrammer ];
    platforms = platforms.linux;
  };
}
