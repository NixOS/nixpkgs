{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "numactl";
  version = "2.0.13";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "08xj0n27qh0ly8hjallnx774gicz15nfq0yyxz8zhgy6pq8l33vv";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
    patchShebangs test
  '';

  # You probably shouldn't ever run these! They will reconfigure Linux
  # NUMA settings, which on my build machine makes the rest of package
  # building ~5% slower until reboot. Ugh!
  doCheck = false; # never ever!

  meta = with stdenv.lib; {
    description = "Library and tools for non-uniform memory access (NUMA) machines";
    homepage = https://github.com/numactl/numactl;
    license = with licenses; [ gpl2 lgpl21 ]; # libnuma is lgpl21
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
  };
}
