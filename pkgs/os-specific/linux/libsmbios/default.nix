{ lib, stdenv, fetchFromGitHub, fetchurl
, pkg-config, autoreconfHook, help2man, gettext, libxml2, perl, python3, doxygen
}:

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
    (fetchurl {
      name = "musl.patch";
      url = "https://git.alpinelinux.org/aports/plain/community/libsmbios/fixes.patch?id=bdc4f67889c958c1266fa5d0cab71c3cd639122f";
      sha256 = "aVVc52OovDYvqWRyKcRAi62daa9AalkKvnVOGvrTmRk=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook doxygen gettext libxml2 help2man perl pkg-config ];

  buildInputs = [ python3 ];

  configureFlags = [ "--disable-graphviz" ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/include
    cp -a src/include/smbios_c $out/include/
    cp -a out/public-include/smbios_c $out/include/
  '';

  # remove forbidden reference to $TMPDIR
  preFixup = ''
    patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$out/sbin/smbios-sys-info-lite"
  '';

  meta = with lib; {
    homepage = "https://github.com/dell/libsmbios";
    description = "Library to obtain BIOS information";
    license = with licenses; [ osl21 gpl2Plus ];
    maintainers = with maintainers; [ ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
