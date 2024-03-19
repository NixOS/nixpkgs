{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, samba
, perl
, openldap
}:

stdenv.mkDerivation rec {
  pname = "enum4linux";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "CiscoCXSecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/R0P4Ft9Y0LZwKwhDGAe36UKviih6CNbJbj1lcNKEkM=";
  };

  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    openldap
    perl
    samba
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp enum4linux.pl $out/bin/enum4linux

    wrapProgram $out/bin/enum4linux \
      --prefix PATH : ${lib.makeBinPath [ samba openldap ]}
  '';

  meta = with lib; {
    description = "A tool for enumerating information from Windows and Samba systems";
    mainProgram = "enum4linux";
    homepage = "https://labs.portcullis.co.uk/tools/enum4linux/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fishi0x01 ];
    platforms = platforms.unix;
  };
}

