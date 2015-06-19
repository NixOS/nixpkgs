{ stdenv, fetchurl, jre, makeWrapper, pcsclite }:

stdenv.mkDerivation rec {
  # TODO: find out what the version components actually mean, if anything:
  package = "eid-viewer-4.0.7-195";
  build = "tcm406-258907";
  name = "${package}-${build}";

  src = fetchurl {
    url = "http://eid.belgium.be/en/binaries/${package}.src.tar_${build}.gz";
    sha256 = "e263e6751ef7c185e278a607fdc46c207306d9a56c6ddb2ce6f58fb4464a2893";
  };

  buildInputs = [ jre pcsclite ];
  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = "tar -xzf ${src} --strip-components=1";

  preConfigure = ''
    substituteInPlace eid-viewer.sh.in --replace "exec java" "exec ${jre}/bin/java"
  '';

  postInstall = ''
    wrapProgram $out/bin/eid-viewer --suffix LD_LIBRARY_PATH : ${pcsclite}/lib
    cat >> $out/share/applications/eid-viewer.desktop << EOF
    # eid-viewer creates XML without a header, making it "plain text":
    MimeType=application/xml;text/xml;text/plain
    EOF
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Belgian electronic identity card (eID) viewer";
    homepage = http://eid.belgium.be/en/using_your_eid/installing_the_eid_software/linux/;
    license = licenses.lgpl3;
    longDescription = ''
      A simple, graphical Java application to view, print and save data from
      Belgian electronic identity cards. Independent of the eid-mw package,
      which is required to actually use your eID for authentication or signing.
    '';
    maintainers = with maintainers; [ nckx ];
    platforms = with platforms; linux;
  };
}
