{ stdenv, fetchFromGitHub, wine, perl, which, coreutils, zenity, curl
, cabextract, unzip, p7zip, gnused, gnugrep, bash } :

let version = "20150316";
in stdenv.mkDerivation rec {
  name = "winetricks-${version}";

  src = fetchFromGitHub {
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;
    sha256 = "00c55jpca6l3v3p02xc0gy5l4xb17gf90282hq5h85nh72kqsbrh";
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
