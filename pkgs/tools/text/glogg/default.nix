{
  mkDerivation,
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  boost,
}:

mkDerivation rec {
  pname = "glogg";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "nickbnf";
    repo = "glogg";
    rev = "v${version}";
    sha256 = "0hf1c2m8n88frmxmyn0ndr8129p7iky49nq565sw1asaydm5z6pb";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace glogg.pro \
      --replace "boost_program_options-mt" "boost_program_options"
  '';

  nativeBuildInputs = [ qmake ];
  buildInputs = [ boost ];

  qmakeFlags = [ "VERSION=${version}" ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/glogg.app $out/Applications/glogg.app
    rm -fr $out/{bin,share}
  '';

  meta = with lib; {
    description = "Fast, smart log explorer";
    mainProgram = "glogg";
    longDescription = ''
      A multi-platform GUI application to browse and search through long or complex log files. It is designed with programmers and system administrators in mind. glogg can be seen as a graphical, interactive combination of grep and less.
    '';
    homepage = "https://glogg.bonnefon.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ c0bw3b ];
  };
}
