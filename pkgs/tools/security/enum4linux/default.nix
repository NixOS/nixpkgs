{ stdenv, fetchurl, makeWrapper, samba, perl, openldap }:

stdenv.mkDerivation rec {
  pname = "enum4linux";
  version = "0.8.9";
  src = fetchurl {
    url = "https://labs.portcullis.co.uk/download/enum4linux-${version}.tar.gz";
    sha256 = "41334df0cb1ba82db9e3212981340372bb355a8160073331d2a1610908a62d85";
  };

  dontBuild = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ samba perl openldap ];

  installPhase = ''
    mkdir -p $out/bin
    cp enum4linux.pl $out/bin/enum4linux

    wrapProgram $out/bin/enum4linux \
      --prefix PATH : ${stdenv.lib.makeBinPath [ samba openldap ]}
  '';

  meta = with stdenv.lib; {
    description = "A tool for enumerating information from Windows and Samba systems";
    homepage = "https://labs.portcullis.co.uk/tools/enum4linux/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.fishi0x01 ];
  };
}

