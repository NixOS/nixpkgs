{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "numactl";
  version = "2.0.16";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aDKzkmvrPDzQl4n0KgeiU5LOLhQA0tmwzGiXvJDp7ZI=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
    patchShebangs test
  '';

  LDFLAGS = lib.optionalString stdenv.hostPlatform.isRiscV "-latomic";

  # You probably shouldn't ever run these! They will reconfigure Linux
  # NUMA settings, which on my build machine makes the rest of package
  # building ~5% slower until reboot. Ugh!
  doCheck = false; # never ever!

  meta = with lib; {
    description = "Library and tools for non-uniform memory access (NUMA) machines";
    homepage = "https://github.com/numactl/numactl";
    license = with licenses; [ gpl2 lgpl21 ]; # libnuma is lgpl21
    platforms = platforms.linux;
  };
}
