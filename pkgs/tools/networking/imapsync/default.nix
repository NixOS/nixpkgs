{ lib
, fetchFromGitHub
, makeWrapper
, perl
, perlPackages
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "imapsync";
  version = "2.229";

  src = fetchFromGitHub {
    owner = "imapsync";
    repo = "imapsync";
    rev = "imapsync-${version}";
    sha256 = "sha256-nlNePOV3Y0atEPSRByRo3dHj/WjIaefEDeWdMKTo4gc=";
  };

  postPatch = ''
    sed -i -e s@/usr@$out@ Makefile
    substituteInPlace INSTALL.d/prerequisites_imapsync --replace "PAR::Packer" ""
  '';

  postInstall = ''
    wrapProgram $out/bin/imapsync --set PERL5LIB $PERL5LIB
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with perlPackages; [
    Appcpanminus
    CGI
    CryptOpenSSLRSA
    DataUniqid
    DistCheckConflicts
    EncodeIMAPUTF7
    FileCopyRecursive
    FileTail
    IOSocketINET6
    IOTee
    JSONWebToken
    LWP
    MailIMAPClient
    ModuleImplementation
    ModuleScanDeps
    NTLM
    PackageStash
    PackageStashXS
    ProcProcessTable
    Readonly
    RegexpCommon
    SysMemInfo
    TermReadKey
    TestDeep
    TestFatal
    TestMockGuard
    TestMockObject
    TestPod
    TestRequires
    UnicodeString
    perl
  ];

  meta = with lib; {
    description = "Mail folder synchronizer between IMAP servers";
    mainProgram = "imapsync";
    homepage = "https://imapsync.lamiral.info/";
    license = licenses.nlpl;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };
}
