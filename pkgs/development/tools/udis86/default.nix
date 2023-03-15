{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, python3
}:

stdenv.mkDerivation rec {
  pname = "udis86";
  version = "unstable-2014-12-25";

  src = fetchFromGitHub {
    owner = "vmt";
    repo = "udis86";
    rev = "56ff6c87c11de0ffa725b14339004820556e343d";
    hash = "sha256-bmm1rgzZeStQJXEmcT8vnplsnmgN3LJlYs7COmqsDU8=";
  };

  patches = [
    (fetchpatch {
      name = "support-python3-for-building";
      url = "https://github.com/vmt/udis86/commit/3c05ce60372cb2eba39d6eb87ac05af8a664e1b1.patch";
      hash = "sha256-uF4Cwt7UMkyd0RX6cCMQt9xvkkUNQvTDH/Z/6nHtVT8=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook python3 ];

  configureFlags = [
    "--enable-shared"
  ];

  outputs = [ "bin" "out" "dev" "lib" ];

  meta = with lib; {
    homepage = "https://udis86.sourceforge.net";
    license = licenses.bsd2;
    maintainers = with maintainers; [ timor ];
    mainProgram = "udcli";
    description = ''
      Easy-to-use, minimalistic x86 disassembler library (libudis86)
    '';
    platforms = platforms.all;
  };
}
