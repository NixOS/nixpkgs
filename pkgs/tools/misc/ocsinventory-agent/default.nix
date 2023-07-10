{ lib
, stdenv
, fetchFromGitHub
, dmidecode
, pciutils
, perlPackages
, shortenPerlShebang
}:

stdenv.mkDerivation rec {
  version = "2.10.0";
  pname = "ocsinventory-agent";

  src = fetchFromGitHub {
    owner = "OCSInventory-NG";
    repo = "UnixAgent";
    rev = "v${version}";
    sha256 = "sha256-TBMnXAw0VbBq0rrU4WMjygqHiZO4qFOUi2NcsVp4eVE=";
  };

  nativeBuildInputs = [ ];
  buildInputs = [
    dmidecode
    pciutils
  ] ++ (with perlPackages; [
    perl
    IOSocketSSL
    LWP
    LWPProtocolHttps
    NetIP
    NetNetmask
    NetSNMP
    XMLSimple
    ProcDaemon
    ProcPIDFile
  ]) ++ lib.optional stdenv.isDarwin shortenPerlShebang;

  buildPhase = ''
    env PERL_AUTOINSTALL=1 perl Makefile.PL
  '';

  outputs = [ "out" ];

  meta = with lib; {
    description = "An agent for ocsinventory NG";
    homepage = "https://github.com/OCSInventory-NG/UnixAgent";
    downloadPage = "https://github.com/OCSInventory-NG/UnixAgent/releases";
    license = licenses.gpl2;
    maintainers = with maintainers; [ totoroot ];
    platforms = platforms.unix;
  };
}
