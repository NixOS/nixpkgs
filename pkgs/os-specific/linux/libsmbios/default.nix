{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, libtool, gettext
, libxml2, perl, doxygen }:


stdenv.mkDerivation rec {
  name = "libsmbios-${version}";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "dell";
    repo = "libsmbios";
    rev = "v${version}";
    sha256 = "1cl5nb6qk8ki87hwqf9n1dd9nlhkjnlpdxlhzvm82za16gs7apkl";
  };

  nativeBuildInputs = [ autoreconfHook doxygen gettext libtool perl pkgconfig ];
  buildInputs = [ libxml2 ];

  configureFlags = [ "--disable-python" "--disable-graphviz" ];

  enableParallelBuilding = true;

  postInstall =
    ''
      mkdir -p $out/include
      cp -a src/include/smbios_c $out/include/
      cp -a out/public-include/smbios_c $out/include/
    '';

  preFixup = ''rm -rf "$(pwd)" ''; # Hack to avoid TMPDIR in RPATHs

  meta = {
    homepage = https://github.com/dell/libsmbios;
    description = "A library to obtain BIOS information";
    license = with stdenv.lib.licenses; [ osl21 gpl2Plus ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
