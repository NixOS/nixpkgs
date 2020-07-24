{ stdenv, fetchFromGitHub, python3, fetchpatch }:

stdenv.mkDerivation rec {
  program = "dex";
  name = "${program}-${version}";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "jceb";
    repo = program;
    rev = "v${version}";
    sha256 = "13dkjd1373mbvskrdrp0865llr3zvdr90sc6a6jqswh3crmgmz4k";
  };

  propagatedBuildInputs = [ python3 ];
  nativeBuildInputs = [ python3.pkgs.sphinx ];
  makeFlags = [ "PREFIX=$(out)" "VERSION=$(version)" ];

  patches = [
    (fetchpatch {
      url = "https://github.com/jceb/dex/commit/107358ddf5e1ca4fa56ef1a7ab161dc3b6adc45a.patch";
      sha256 = "06dfkfzxp8199by0jc5wim8g8qw38j09dq9p6n9w4zaasla60pjq";
    })
  ];

  meta = with stdenv.lib; {
    description = "A program to generate and execute DesktopEntry files of the Application type";
    homepage = "https://github.com/jceb/dex";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
