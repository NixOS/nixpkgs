{ cmake
, fetchFromGitLab
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bcunit";
  # Latest release 3.0.2 is missing some functions needed by bctoolbox. See:
  # https://gitlab.linphone.org/BC/public/bcunit/issues/1
  version = "unstable-2019-11-19";

  buildInputs = [ cmake ];
  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = "3c720fbf67dd3c02b0c7011ed4036982b2c93532";
    sha256 = "1237hpmkls2igp60gdfkbknxpgwvxn1vmv2m41vyl25xw1d3g35w";
  };

  meta = with stdenv.lib; {
    inherit version;
    description = "A fork of CUnit test framework";
    homepage = "https://gitlab.linphone.org/BC/public/bcunit";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ raskin jluttine ];
    platforms = platforms.linux;
  };
}
