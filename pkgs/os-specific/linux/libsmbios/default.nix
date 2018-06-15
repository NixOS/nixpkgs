{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, help2man, gettext
, libxml2, perl, python3, doxygen }:


stdenv.mkDerivation rec {
  name = "libsmbios-${version}";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "dell";
    repo = "libsmbios";
    rev = "v${version}";
    sha256 = "158w5fz777is7nr5yhpr69b17nn6i1pavycxq1q9899frrpkzbsc";
  };

  nativeBuildInputs = [ autoreconfHook doxygen gettext libxml2 help2man perl pkgconfig ];

  buildInputs = [ python3 ];

  configureFlags = [ "--disable-graphviz" ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/include
    cp -a src/include/smbios_c $out/include/
    cp -a out/public-include/smbios_c $out/include/
  '';

  preFixup = ''rm -rf "$(pwd)" ''; # Hack to avoid TMPDIR in RPATHs

  meta = with stdenv.lib; {
    homepage = https://github.com/dell/libsmbios;
    description = "A library to obtain BIOS information";
    license = with licenses; [ osl21 gpl2Plus ];
    maintainers = with maintainers; [ ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
