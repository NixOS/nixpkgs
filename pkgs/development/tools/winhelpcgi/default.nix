{ stdenv, fetchurl, libwmf, libpng, pkg-config, lib }: stdenv.mkDerivation {
  name = "winhelpcgi-1.0-rc3";

  src = fetchurl {
    url = "http://www.herdsoft.com/ftp/winhelpcgi_1.0-1.tar.gz";
    sha256 = "sha256-9HIs50ZGoTfGixD9c/DQs0KJMQtmfsDVB8qRMnQtXNw=";

  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libwmf libpng ];

  meta = {
    description = "CGI module for Linux, Solaris, MacOS X and AIX to read Windows Help Files";

    homepage = "http://www.herdsoft.com/linux/produkte/winhelpcgi.html";

    license = lib.licenses.gpl2Only;

    maintainers = [ lib.maintainers.shlevy ];
  };
}
