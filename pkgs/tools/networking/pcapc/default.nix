{ stdenv, fetchFromGitHub, libpcap }:

stdenv.mkDerivation rec {
  name = "pcapc-${version}";
  version = "2015-03-06";

  src = fetchFromGitHub {
    sha256 = "02j45wmxy8qcji0giwx3364pbqb6849s8y0xfvzx40g98mssl027";
    rev = "9dddf52e65c8cff72c7c11758a951b31bf083436";
    repo = "pcapc";
    owner = "pfactum";
  };

  buildInputs = [ libpcap ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  doCheck = false;

  postInstall = ''
    install -Dm644 {.,$out/share/doc/pcapc}/README.md
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Compile libpcap filter expressions into BPF opcodes";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
