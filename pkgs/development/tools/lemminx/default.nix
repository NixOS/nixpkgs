{ stdenv, lib, fetchurl, unzip, zlib, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "lemminx";
  version = "0.22.0";

  src = fetchurl {
    url = "https://github.com/redhat-developer/vscode-xml/releases/download/${version}/lemminx-linux.zip";
    sha256 = "sha256-cbRqdgYHHClnlTWgA1vBdbAT6EzD7ygvfM9Zppl5czo=";
  };

  nativeBuildInputs = [ unzip autoPatchelfHook ];
  buildInputs = [ zlib ];

  unpackPhase = ''
    unzip $src
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin

    cp lemminx-linux $out/bin/lemminx
  '';

  meta = with lib; {
    homepage = "https://github.com/eclipse/lemminx";
    description = "XML Language server";
    longDescription = ''
      LemMinX is a XML language specific implementation of the Language Server Protocol and can be used
      with any editor that supports the protocol, to offer good support for the XML Language.
    '';
    license = lib.licenses.epl20;
    maintainers = with maintainers; [ tshaynik ];
    platforms = platforms.linux;
  };
}
