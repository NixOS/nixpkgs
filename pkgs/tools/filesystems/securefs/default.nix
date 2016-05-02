{ stdenv, fetchFromGitHub
, fuse }:

stdenv.mkDerivation rec {
  name = "securefs-${version}";
  version = "0.3.1";

  src = fetchFromGitHub {
    sha256 = "1n9kgrvc600lfclrk8cj2zy8md1brqhs8kvzdwfxgxavdh0wakkc";
    rev = version;
    repo = "securefs";
    owner = "netheril96";
  };

  buildInputs = [ fuse ];

  enableParallelBuilding = true;

  doCheck = false; # tests require the fuse module to be loaded

  installPhase = ''
    install -D -m0755 {.,$out/bin}/securefs
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Transparent encryption filesystem";
    longDescription = ''
      Securefs is a filesystem in userspace (FUSE) that transparently encrypts
      and authenticates data stored. It is particularly designed to secure
      data stored in the cloud.
      Securefs mounts a regular directory onto a mount point. The mount point
      appears as a regular filesystem, where one can read/write/create files,
      directories and symbolic links. The underlying directory will be
      automatically updated to contain the encrypted and authenticated
      contents.
    '';
    license = with licenses; [ bsd2 mit ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
