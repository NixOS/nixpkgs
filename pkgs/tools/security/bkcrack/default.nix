{ lib
, stdenv
, fetchFromGitHub
, cmake
, openmp
}:

stdenv.mkDerivation rec {
  pname = "bkcrack";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "kimci86";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iyx4mOTr6MHECk9S9zrIAE5pt+cxWnOKS7iQPUyWfzs=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openmp ];

  postInstall = ''
    mkdir -p $out/bin $out/share/licenses/bkcrack
    mv $out/bkcrack $out/bin/
    mv $out/license.txt $out/share/licenses/bkcrack
    rm -r $out/example $out/tools $out/readme.md
  '';

  meta = with lib; {
    description = "Crack legacy zip encryption with Biham and Kocher's known plaintext attack";
    homepage = "https://github.com/kimci86/bkcrack";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ erdnaxe ];
  };
}
