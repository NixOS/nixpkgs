{ stdenv, fetchurl, libelf, txt2man }:

stdenv.mkDerivation rec {
  name = "bin_replace_string-${version}";
  version = "0.2";

  src = fetchurl {
    sha256 = "1gnpddxwpsfrg4l76x5yplsvbcdbviybciqpn22yq3g3qgnr5c2a";
    url = "ftp://ohnopub.net/mirror/bin_replace_string-0.2.tar.bz2";
  };

  buildInputs = [ libelf ];
  nativeBuildInputs = [ txt2man ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Edit precompiled binaries";
    longDescription = ''
      bin_replace_string edits C-style strings in precompiled binaries. This is
      intended to be useful to replace arbitrary strings in binaries whose
      source code is not available. However, because of the nature of compiled
      binaries, bin_replace_string may only replace a given C-string with a
      shorter C-string.
    '';
    homepage = http://ohnopub.net/~ohnobinki/bin_replace_string/;
    downloadPage = ftp://ohnopub.net/mirror/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
