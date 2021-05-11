{ lib, stdenv
, clarissa
, clar-oui
, asciidoctor
, dnsutils
, makeWrapper
}:

stdenv.mkDerivation rec {

  pname = "clar";
  version = clarissa.version;

  src = clarissa.src;

  nativeBuildInputs = [ asciidoctor makeWrapper ];

  outputs = [ "out" "man" ];

  makeFlags = [ "DESTDIR=${placeholder "out"}" "PREFIX=" ];

  dontBuild = true;
  installTargets = [ "install-clar" ];
  postInstall = ''
    wrapProgram $out/bin/clar \
      --prefix PATH : ${lib.makeBinPath [ clarissa dnsutils ]} \
      --set CLAR_OUI ${clar-oui}/share/misc/clar_OUI.csv
  '';

  meta = with lib; {
    description = "Utility for using clarissa's output";
    longDescription = ''
      This utility uses clarissa's output to provide a variety of formats and functions.
      Such as: presenting the MAC and IP addresses along with an associated domain name
      and the MAC vendor ID,
      provide a near instantaneous arp-scan like output
      and accessing clarissa's output without installing the daemon in the environment.
    '';
    homepage = "https://gitlab.com/evils/clarissa";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.evils ];
  };
}
