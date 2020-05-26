{ stdenv, buildPackages, fetchFromGitHub, fetchurl, pkgconfig, popt }:

stdenv.mkDerivation rec {
  pname = "efivar";
  version = "37";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "efivar";
    rev = version;
    sha256 = "1z2dw5x74wgvqgd8jvibfff0qhwkc53kxg54v12pzymyibagwf09";
  };
  patches = [
    (fetchurl {
      name = "r13y.patch";
      url = "https://patch-diff.githubusercontent.com/raw/rhboot/efivar/pull/133.patch";
      sha256 = "038cwldb8sqnal5l6mhys92cqv8x7j8rgsl8i4fiv9ih9znw26i6";
    })
    (fetchurl {
      name = "fix-misaligned-pointer.patch";
      url = "https://github.com/rhboot/efivar/commit/b98ba8921010d03f46704a476c69861515deb1ca.patch";
      sha256 = "0ni9mz7y40a2wf1d1q5n9y5dhcbydxvfdhqic7zsmgnaxs3a0p27";
    })
    (fetchurl {
      name = "fix-gcc9-error.patch";
      url = "https://github.com/rhboot/efivar/commit/c3c553db85ff10890209d0fe48fb4856ad68e4e0.patch";
      sha256 = "0lc38npydp069nlcga25wzzm204ww9l6mpjfn6wmhdfhn0pgjwky";
    })
  ];
  # We have no LTO here since commit 22284b07.
  postPatch = if stdenv.isi686 then "sed '/^OPTIMIZE /s/-flto//' -i Make.defaults" else null;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ popt ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  makeFlags = [
    "prefix=$(out)"
    "libdir=$(out)/lib"
    "bindir=$(bin)/bin"
    "mandir=$(man)/share/man"
    "includedir=$(dev)/include"
    "PCDIR=$(dev)/lib/pkgconfig"
  ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Tools and library to manipulate EFI variables";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
