{ faad2
, fetchFromGitHub
, flac
, lame
, lib
, makeWrapper
, monkeysAudio
, nixosTests
, perl538Packages
, sox
, stdenv
, wavpack
, zlib
, enableUnfreeFirmware ? false
}:

let
  perlPackages = perl538Packages;

  binPath = lib.makeBinPath ([ lame flac faad2 sox wavpack ] ++ (lib.optional stdenv.isLinux monkeysAudio));
  libPath = lib.makeLibraryPath [ zlib stdenv.cc.cc.lib ];
in
perlPackages.buildPerlPackage rec {
  pname = "slimserver";
  version = "8.3.1";

  src = fetchFromGitHub {
    owner = "Logitech";
    repo = "slimserver";
    rev = version;
    hash = "sha256-yMFOwh/oPiJnUsKWBGvd/GZLjkWocMAUK0r+Hx/SUPo=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with perlPackages; [
    AnyEvent
    ArchiveZip
    AsyncUtil
    AudioScan
    CarpClan
    CGI
    ClassAccessor
    ClassAccessorChained
    ClassC3
    # ClassC3Componentised # Error: DBIx::Class::Row::throw_exception(): DBIx::Class::Relationship::BelongsTo::belongs_to(): Can't infer join condition for track
    ClassDataInheritable
    ClassInspector
    ClassISA
    ClassMember
    ClassSingleton
    ClassVirtual
    ClassXSAccessor
    CompressRawZlib
    CryptOpenSSLRSA
    DataDump
    DataPage
    DataURIEncode
    DBDSQLite
    DBI
    # DBIxClass # https://github.com/Logitech/slimserver/issues/138
    DigestSHA1
    EncodeDetect
    EV
    ExporterLite
    FileBOM
    FileCopyRecursive
    FileNext
    FileReadBackwards
    FileSlurp
    FileWhich
    HTMLParser
    HTTPCookies
    HTTPDaemon
    HTTPMessage
    ImageScale
    IOAIO
    IOInterface
    IOSocketSSL
    IOString
    JSONXS
    JSONXSVersionOneAndTwo
    # LogLog4perl # Internal error: Root Logger not initialized.
    LWP
    LWPProtocolHttps
    MP3CutGapless
    NetHTTP
    NetHTTPSNB
    PathClass
    ProcBackground
    # SQLAbstract # DBI Exception: DBD::SQLite::db prepare_cached failed: no such function: ARRAY
    SQLAbstractLimit
    SubName
    TemplateToolkit
    TextUnidecode
    TieCacheLRU
    TieCacheLRUExpires
    TieRegexpHash
    TimeDate
    URI
    URIFind
    UUIDTiny
    XMLParser
    XMLSimple
    YAMLLibYAML
  ]
  # ++ (lib.optional stdenv.isDarwin perlPackages.MacFSEvents)
  ++ (lib.optional stdenv.isLinux perlPackages.LinuxInotify2);

  prePatch = ''
    # remove vendored binaries
    rm -rf Bin

    # remove most vendored modules, keeping necessary ones
    mkdir -p CPAN_used/Class/C3/ CPAN_used/SQL
    rm -r CPAN/SQL/Abstract/Limit.pm
    cp -rv CPAN/Class/C3/Componentised.pm CPAN_used/Class/C3/
    cp -rv CPAN/DBIx CPAN_used/
    cp -rv CPAN/Log CPAN_used/
    cp -rv CPAN/SQL/* CPAN_used/SQL/
    rm -r CPAN
    mv CPAN_used CPAN

    # another set of vendored/modified modules exist in lib, more selectively cleaned for now
    rm -rf lib/Audio

    ${lib.optionalString (!enableUnfreeFirmware) ''
      # remove unfree firmware
      rm -rf Firmware
    ''}

    touch Makefile.PL
  '';

  doCheck = false;

  installPhase = ''
    cp -r . $out
    wrapProgram $out/slimserver.pl --prefix LD_LIBRARY_PATH : "${libPath}" --prefix PATH : "${binPath}"
    wrapProgram $out/scanner.pl --prefix LD_LIBRARY_PATH : "${libPath}" --prefix PATH : "${binPath}"
    mkdir $out/bin
    ln -s $out/slimserver.pl $out/bin/slimserver
  '';

  outputs = [ "out" ];

  passthru.tests = {
    inherit (nixosTests) slimserver;
  };

  meta = with lib; {
    homepage = "https://github.com/Logitech/slimserver";
    description = "Server for Logitech Squeezebox players. This server is also called Logitech Media Server";
    # the firmware is not under a free license, but not included in the default package
    # https://github.com/Logitech/slimserver/blob/public/8.3/License.txt
    license = if enableUnfreeFirmware then licenses.unfree else licenses.gpl2Only;
    mainProgram = "slimserver";
    maintainers = with maintainers; [ adamcstephens jecaro ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
