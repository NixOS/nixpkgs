{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, zlib
}:

stdenv.mkDerivation rec {
  pname = "marksman";
  version = "2022-07-31";

  src = fetchurl {
    url = "https://github.com/artempyanykh/marksman/releases/download/2022-07-31/marksman-linux";
    sha256 = "sha256-f7p6cRDnJ+0Bvq6ACdXDZt4rVmFVLSHVITmU5/ChUYA=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
  ];

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    install -Dm755 ${src} $out/bin/marksman
  '';

  meta = with lib; {
    description = "Markdown LSP server providing completion, cross-references, diagnostics, and more";
    homepage = "https://github.com/artempyanykh/marksman";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ onny ];
  };
}
