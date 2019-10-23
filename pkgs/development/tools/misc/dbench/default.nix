{ stdenv, fetchgit, autoconf, popt, zlib }:

stdenv.mkDerivation {
  name = "dbench-2013-01-01";

  src = fetchgit {
    url = git://git.samba.org/sahlberg/dbench.git;
    rev = "65b19870ed8d25bff14cafa1c30beb33f1fb6597";
    sha256 = "16lcbwmmx8z5i73k3dnf54yffrpx7ql3y9k3cpkss9dcyxb1p83i";
  };

  buildInputs = [ autoconf popt zlib ];

  patches = [
    # patch has been also sent upstream and might be included in future versions
    ./fix-missing-stdint.patch
  ];

  preConfigure = ''
    ./autogen.sh
    configureFlagsArray+=("--datadir=$out/share/dbench")
  '';

  postInstall = ''
    cp -R loadfiles/* $out/share/dbench/doc/dbench/loadfiles

    # dbench looks here for the file
    ln -s doc/dbench/loadfiles/client.txt $out/share/dbench/client.txt

    # backwards compatible to older nixpkgs packaging introduced by
    # 3f27be8e5d5861cd4b9487d6c5212d88bf24316d
    ln -s dbench/doc/dbench/loadfiles $out/share/loadfiles
  '';

  meta = with stdenv.lib; {
    description = "Filesystem benchmark tool based on load patterns";
    homepage = https://dbench.samba.org/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
