{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
}:
buildGhidraExtension (finalAttrs: {
  pname = "lightkeeper";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "WorksButNotTested";
    repo = "lightkeeper";
    rev = finalAttrs.version;
    hash = "sha256-UBzGs9PKkGjWDL+12mMXMfNm/vqiKlzs16rWRBnCiTw=";
  };
  preConfigure = ''
    cd lightkeeper
  '';
  meta = {
    description = "Port of the Lighthouse plugin to GHIDRA";
    homepage = "https://github.com/WorksButNotTested/lightkeeper";
    license = lib.licenses.asl20;
  };
})
