{ lib, fetchFromGitHub, python2Packages, imagemagick, exiftool, file, ghostscript }:

python2Packages.buildPythonApplication rec {
  pname = "pdf-redact-tools";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "firstlookmedia";
    repo = pname;
    rev = "v${version}";
    sha256 = "01vs1bc0pfgk6x2m36vwra605fg59yc31d0hl9jmj86n8q6wwvss";
  };

  patchPhase = ''substituteInPlace pdf-redact-tools      \
    --replace \'convert\' \'${imagemagick}/bin/convert\' \
    --replace \'exiftool\' \'${exiftool}/bin/exiftool\'  \
    --replace \'file\' \'${file}/bin/file\'
   '';

  propagatedBuildInputs = [ imagemagick exiftool ghostscript ];

  meta = with lib; {
    description = "Redact and strip metadata from documents before publishing";
    longDescription = ''
        PDF Redact Tools helps with securely redacting and stripping metadata
        from documents before publishing. Note that this is not a security tool.
        It uses ImageMagick to parse PDFs.  While ImageMagick is a versatile tool, it has
        a history of several security bugs. A malicious PDF could exploit a bug in
        ImageMagick to take over your computer. If you're working with potentially
        malicious PDFs, it's safest to run them through PDF Redact Tools in an isolated
        environment, such as a virtual machine, or by using a tool such as the Qubes
        PDF Converter instead.
    '';
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ leenaars ];
  };
}
