{ faad2
, fetchFromGitHub
, flac
, lame
, lib
, makeWrapper
, monkeysAudio
, perl534Packages
, sox
, stdenv
, wavpack
, zlib
}:

perl534Packages.buildPerlPackage rec {
  pname = "slimserver";
  version = "8.3.1";

  src = fetchFromGitHub {
    owner = "Logitech";
    repo = "slimserver";
    rev = version;
    hash = "sha256-yMFOwh/oPiJnUsKWBGvd/GZLjkWocMAUK0r+Hx/SUPo=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl534Packages.CryptOpenSSLRSA perl534Packages.IOSocketSSL ];

  prePatch = ''
    rm -rf Bin
    touch Makefile.PL
  '';

  doCheck = false;

  installPhase = ''
    cp -r . $out
    wrapProgram $out/slimserver.pl \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ zlib stdenv.cc.cc.lib ]}" \
      --prefix PATH : "${lib.makeBinPath [ lame flac faad2 sox monkeysAudio wavpack ]}"
  '';

  outputs = [ "out" ];

  meta = with lib; {
    homepage = "https://github.com/Logitech/slimserver";
    description = "Server for Logitech Squeezebox players. This server is also called Logitech Media Server";
    # the firmware is not under a free license!
    # https://github.com/Logitech/slimserver/blob/public/8.3/License.txt
    license = licenses.unfree;
    maintainers = with maintainers; [ adamcstephens jecaro ];
    platforms = platforms.unix;
  };
}
