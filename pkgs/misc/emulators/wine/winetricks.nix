{ stdenv, fetchgit, wine, perl, which, coreutils, zenity, curl
, cabextract, unzip, p7zip, gnused, gnugrep, bash } :

stdenv.mkDerivation rec {
  name = "winetricks-20150206";

  src = fetchgit {
    url = "https://code.google.com/p/winetricks/";
    rev = "483056823093a90c9186b3d1a4867f481acf5fa1";
    sha256 = "8b86a2a130ced405886775f0f81e7a6b25eb1bc22f357d0fe705fead52fff829";
  };

  buildInputs = [ perl which ];

  # coreutils is for sha1sum
  pathAdd = stdenv.lib.concatMapStringsSep ":" (x: x + "/bin")
    [ wine perl which coreutils zenity curl cabextract unzip p7zip gnused gnugrep bash ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    sed -i \
      -e '2i PATH="${pathAdd}:$PATH"' \
      "$out/bin/winetricks"
  '';

  meta = {
    description = "A script to install DLLs needed to work around problems in Wine";
    license = stdenv.lib.licenses.lgpl21;
    homepage = http://code.google.com/p/winetricks/;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
