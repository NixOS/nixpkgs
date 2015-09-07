{ stdenv, fetchurl, jre, makeWrapper, pcsclite }:

let
  # TODO: find out what the version components actually mean, if anything:
  major = "4.1.4-v4.1.4";
  minor = "tcm406-270732";
  version = "${major}-${minor}";
in stdenv.mkDerivation rec {
  name = "eid-viewer-${version}";

  src = fetchurl {
    url = "http://eid.belgium.be/en/binaries/eid-viewer-${major}.src.tar_${minor}.gz";
    sha256 = "06kda45y7c3wvvqby153zcasgz4jibjypv8gvfwvrwvn4ag2z934";
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
    inherit version;
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
