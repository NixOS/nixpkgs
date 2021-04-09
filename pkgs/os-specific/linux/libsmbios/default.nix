{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook, help2man, gettext
, fetchpatch, libxml2, perl, python3, doxygen }:


stdenv.mkDerivation rec {
  pname = "libsmbios";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "dell";
    repo = "libsmbios";
    rev = "v${version}";
    sha256 = "0krwwydyvb9224r884y1mlmzyxhlfrcqw73vi1j8787rl0gl5a2i";
  };

  patches = [
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/testing/libsmbios_c/fixes.patch?id=d41429e184408e6a35f789ca19296ef37559ea47";
      sha256 = "sha256-vMiqYyuFI5QVvgVyiz3oBYi0M6tO/D3Q3vJ+IWCCh4M=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook doxygen gettext libxml2 help2man perl pkg-config ];

  buildInputs = [ python3 libxml2 ];

  configureFlags = [
    "--disable-graphviz"
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/include
    cp -a src/include/smbios_c $out/include/
    cp -a out/public-include/smbios_c $out/include/
  '';

  preFixup = ''rm -rf "$(pwd)" ''; # Hack to avoid TMPDIR in RPATHs

  meta = with lib; {
    homepage = "https://github.com/dell/libsmbios";
    description = "A library to obtain BIOS information";
    license = with licenses; [ osl21 gpl2Plus ];
    maintainers = with maintainers; [ ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
