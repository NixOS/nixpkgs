{ stdenv, fetchurl, makeWrapper, jre, pcsclite }:

stdenv.mkDerivation rec {
  name = "eid-viewer-${version}";
  version = "4.1.9";

  src = fetchurl {
    url = "https://downloads.services.belgium.be/eid/eid-viewer-${version}-v${version}.src.tar.gz";
    sha256 = "0bq9jl4kl97j0dfhz4crcb1wqhn420z5vpg510zadvrmqjhy1x4g";
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
    platforms = platforms.linux;
  };
}
