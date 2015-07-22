{ stdenv, fetchFromGitHub, wine, perl, which, coreutils, zenity, curl
, cabextract, unzip, p7zip, gnused, gnugrep, bash } :

let v = (import ./versions.nix).winetricks;
in stdenv.mkDerivation rec {
  name = "winetricks-${v.version}";

  src = fetchFromGitHub {
    owner = "Winetricks";
    repo = "winetricks";
    rev = v.version;
    sha256 = v.sha256;
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
