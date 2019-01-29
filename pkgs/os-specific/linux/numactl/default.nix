{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "numactl-${version}";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "numactl";
    repo = "numactl";
    rev = "v${version}";
    sha256 = "0crhpxwakp0gvd7wwpbkfd3brnrdf89lkbf03axnbrs0b6kaygg2";
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
