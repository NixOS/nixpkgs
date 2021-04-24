{ lib, stdenv, fetchFromGitHub, fetchpatch, libbfd, zlib, libiberty }:

stdenv.mkDerivation rec {
  pname = "wimboot";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "ipxe";
    repo = "wimboot";
    rev = "v${version}";
    sha256 = "134wqqr147az5vbj4szd0xffwa99b4rar7w33zm3119zsn7sd79k";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-address-of-packed-member"; # Fails on gcc9

  patches = [
    # Fixes for newer binutils
    # Add R_X86_64_PLT32 as known reloc target
    (fetchpatch {
      url = "https://github.com/ipxe/wimboot/commit/91be50c17d4d9f463109d5baafd70f9fdadd86db.patch";
      sha256 = "113448n49hmk8nz1dxbhxiciwl281zwalvb8z5p9xfnjvibj8274";
    })
    # Fix building with binutils 2.34 (bfd_get_section_* removed in favour of bfd_section_*)
    (fetchpatch {
      url = "https://github.com/ipxe/wimboot/commit/2f97e681703d30b33a4d5032a8025ab8b9f2de75.patch";
      sha256 = "0476mp74jaq3k099b654al6yi2yhgn37d9biz0wv3ln2q1gy94yf";
    })
  ];

  # We cannot use sourceRoot because the patch wouldn't apply
  postPatch = ''
    cd src
  '';

  hardeningDisable = [ "pic" ];

  buildInputs = [ libbfd zlib libiberty ];
  makeFlags = [ "wimboot.x86_64.efi" ];

  installPhase = ''
    mkdir -p $out/share/wimboot/
    cp wimboot.x86_64.efi $out/share/wimboot
  '';

  meta = with lib; {
    homepage = "https://ipxe.org/wimboot";
    description = "Windows Imaging Format bootloader";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ das_j ajs124 ];
    platforms = platforms.x86; # Fails on aarch64
  };
}
