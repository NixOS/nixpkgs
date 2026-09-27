{
  lib,
  mkTclDerivation,
  fetchFromGitHub,

  tk,

  libx11,
  libxcursor,
}:
mkTclDerivation rec {
  pname = "tkdnd";
  version = "2.9.5";

  src = fetchFromGitHub {
    owner = "petasis";
    repo = "tkdnd";
    tag = "tkdnd-release-test-v${version}";
    hash = "sha256-VF1f9HSEThyFy3u7d3Kvo7EIpoosz6KpLOiHkf89PQI=";
  };

  configureFlags = [
    "--with-tk=${tk}/lib"
    "--with-tkinclude=${lib.getDev tk}/include"
  ];

  buildInputs = [
    libx11
    libxcursor
  ];

  meta = {
    description = "Extension to the Tk toolkit that adds native drag and drop support";
    homepage = "https://github.com/petasis/tkdnd";
    changelog = "https://github.com/petasis/tkdnd/raw/refs/tags/${src.tag}/Changelog";
    license = lib.licenses.tcltk;
    maintainers = [ lib.maintainers.ryand56 ];
  };
}
