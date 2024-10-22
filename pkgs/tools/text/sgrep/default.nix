{ stdenv, sgrep, fetchurl, runCommand, lib, m4, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "sgrep";
  version = "1.94a";

  src = fetchurl {
    url = "https://www.cs.helsinki.fi/pub/Software/Local/Sgrep/sgrep-${version}.tar.gz";
    sha256 = "sha256-1bFkeOOrRHNeJCg9LYldLJyAE5yVIo3zvbKsRGOV+vk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/sgrep \
      --prefix PATH : ${lib.makeBinPath [ m4 ]}
  '';

  passthru.tests.smokeTest = runCommand "test-sgrep" { } ''
    expr='"<foo>" __ "</foo>"'
    data="<foo>1</foo><bar>2</bar>"
    ${sgrep}/bin/sgrep "$expr" <<<$data >$out
    read result <$out
    [[ $result = 1 ]]
  '';

  meta = with lib; {
    homepage = "https://www.cs.helsinki.fi/u/jjaakkol/sgrep.html";
    description = "Grep for structured text formats such as XML";
    mainProgram = "sgrep";
    longDescription = ''
      sgrep (structured grep) is a tool for searching and indexing text,
      SGML, XML and HTML files and filtering text streams using
      structural criteria.
    '';
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ eigengrau ];
  };
}
