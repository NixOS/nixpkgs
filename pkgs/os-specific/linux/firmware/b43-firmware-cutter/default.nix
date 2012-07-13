{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "b43-fwcutter-015";

  src = fetchurl {
    url = "http://bues.ch/b43/fwcutter/${name}.tar.bz2";
    sha256 = "1sznw1jrhyfbx0ilwzrj6mzlgc96fzjbx56j4ji8lsypyp8m6sjc";
  };

  patches = [ ./no-root-install.patch ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Firmware extractor for cards supported by the b43 kernel module";
    homepage = http://wireless.kernel.org/en/users/Drivers/b43;
    license = "free-non-copyleft";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}

