{
  lib,
  python3Packages,
  fetchzip,
}:

python3Packages.buildPythonApplication {
  pname = "pdf-parser";
  version = "0.7.4";

  src = fetchzip {
    url = "https://didierstevens.com/files/software/pdf-parser_V0_7_4.zip";
    sha256 = "1j39yww2yl4cav8xgd4zfl5jchbbkvffnrynkamkzvz9dd5np2mh";
  };

  format = "other";

  installPhase = ''
    install -Dm555 pdf-parser.py $out/bin/pdf-parser.py
  '';

  preFixup = ''
    substituteInPlace $out/bin/pdf-parser.py \
      --replace '/usr/bin/python' '${python3Packages.python}/bin/python'
  '';

  meta = with lib; {
    description = "Parse a PDF document";
    longDescription = ''
      This tool will parse a PDF document to identify the fundamental elements used in the analyzed file.
      It will not render a PDF document.
    '';
    homepage = "https://blog.didierstevens.com/programs/pdf-tools/";
    license = licenses.publicDomain;
    maintainers = [ maintainers.lightdiscord ];
    platforms = platforms.all;
    mainProgram = "pdf-parser.py";
  };
}
