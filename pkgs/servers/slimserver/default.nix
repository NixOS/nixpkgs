<<<<<<< HEAD
{ faad2
, fetchFromGitHub
, flac
, lame
, lib
, makeWrapper
, monkeysAudio
, perlPackages
, sox
, stdenv
, wavpack
, zlib
=======
{ lib
, fetchFromGitHub
, makeWrapper
, perlPackages
, flac
, faad2
, sox
, lame
, monkeysAudio
, wavpack
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

perlPackages.buildPerlPackage rec {
  pname = "slimserver";
<<<<<<< HEAD
  version = "8.3.1";
=======
  version = "7.9.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Logitech";
    repo = "slimserver";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-yMFOwh/oPiJnUsKWBGvd/GZLjkWocMAUK0r+Hx/SUPo=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perlPackages.CryptOpenSSLRSA perlPackages.IOSocketSSL ];

  prePatch = ''
    rm -rf Bin
    touch Makefile.PL
=======
    hash = "sha256-P4CSu/ff6i48uWV5gXsJgayZ1S1s0RAqa5O5y3Y0g9Y=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    perlPackages.perl
    perlPackages.AnyEvent
    perlPackages.ArchiveZip
    perlPackages.AudioScan
    perlPackages.CarpClan
    perlPackages.CGI
    perlPackages.ClassXSAccessor
    perlPackages.DataDump
    perlPackages.DataURIEncode
    perlPackages.DBDSQLite
    perlPackages.DBI
    perlPackages.DBIxClass
    perlPackages.DigestSHA1
    perlPackages.EV
    perlPackages.ExporterLite
    perlPackages.FileBOM
    perlPackages.FileCopyRecursive
    perlPackages.FileNext
    perlPackages.FileReadBackwards
    perlPackages.FileSlurp
    perlPackages.FileWhich
    perlPackages.HTMLParser
    perlPackages.HTTPCookies
    perlPackages.HTTPDaemon
    perlPackages.HTTPMessage
    perlPackages.ImageScale
    perlPackages.IOSocketSSL
    perlPackages.IOString
    perlPackages.JSONXSVersionOneAndTwo
    perlPackages.LogLog4perl
    perlPackages.LWP
    perlPackages.NetHTTP
    perlPackages.NetHTTPSNB
    perlPackages.ProcBackground
    perlPackages.SubName
    perlPackages.TemplateToolkit
    perlPackages.TextUnidecode
    perlPackages.TieCacheLRU
    perlPackages.TieCacheLRUExpires
    perlPackages.TieRegexpHash
    perlPackages.TimeDate
    perlPackages.URI
    perlPackages.URIFind
    perlPackages.UUIDTiny
    perlPackages.XMLParser
    perlPackages.XMLSimple
    perlPackages.YAMLLibYAML
  ];


  prePatch = ''
    mkdir CPAN_used
    # slimserver doesn't work with current DBIx/SQL versions, use bundled copies
    mv CPAN/DBIx CPAN/SQL CPAN_used
    rm -rf CPAN
    rm -rf Bin
    touch Makefile.PL

    # relax audio scan version constraints
    substituteInPlace lib/Audio/Scan.pm --replace "0.93" "1.01"
    substituteInPlace modules.conf --replace "Audio::Scan 0.93 0.95" "Audio::Scan 0.93"
  '';

  preConfigurePhase = "";

  buildPhase = ''
    mv lib tmp
    mkdir -p ${perlPackages.perl.libPrefix}
    mv CPAN_used/* ${perlPackages.perl.libPrefix}
    cp -rf tmp/* ${perlPackages.perl.libPrefix}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  doCheck = false;

  installPhase = ''
    cp -r . $out
    wrapProgram $out/slimserver.pl \
<<<<<<< HEAD
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ zlib stdenv.cc.cc.lib ]}" \
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      --prefix PATH : "${lib.makeBinPath [ lame flac faad2 sox monkeysAudio wavpack ]}"
  '';

  outputs = [ "out" ];

  meta = with lib; {
    homepage = "https://github.com/Logitech/slimserver";
    description = "Server for Logitech Squeezebox players. This server is also called Logitech Media Server";
    # the firmware is not under a free license!
<<<<<<< HEAD
    # https://github.com/Logitech/slimserver/blob/public/8.3/License.txt
    license = licenses.unfree;
    maintainers = with maintainers; [ adamcstephens jecaro ];
=======
    # https://github.com/Logitech/slimserver/blob/public/7.9/License.txt
    license = licenses.unfree;
    maintainers = [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.unix;
  };
}
