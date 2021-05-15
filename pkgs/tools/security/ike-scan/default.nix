{ lib
, autoconf
, automake
, autoreconfHook
, fetchFromGitHub
, fetchpatch
, openssl
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "ike-scan";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "royhills";
    repo = pname;
    rev = version;
    sha256 = "01a39bk9ma2lm59q320m9g11909if5gc3qynd8pzn6slqiq5r8kw";
  };

  nativeBuildInputs = [
    autoreconfHook
    openssl
  ];

  configureFlags = [ "--with-openssl=${openssl.dev}" ];

  patches = [
    # Using the same patches as for the Fedora RPM
    (fetchpatch {
      # Memory leaks, https://github.com/royhills/ike-scan/pull/15
      url = "https://github.com/royhills/ike-scan/pull/15/commits/d864811de08dcddd65ac9b8d0f2acf5d7ddb9dea.patch";
      sha256 = "0wbrq89dl8js7cdivd0c45hckmflan33cpgc3qm5s3az6r4mjljm";
    })
    (fetchpatch {
      # Unknown vendor IDs,  https://github.com/royhills/ike-scan/pull/18, was merged but not released
      url = "https://github.com/royhills/ike-scan/pull/18/commits/e065ddbe471880275dc7975e7da235e7a2097c22.patch";
      sha256 = "13ly01c96nnd5yh7rxrhv636csm264m5xf2a1inprrzxkkri5sls";
    })
  ];

  meta = with lib; {
    description = "Tool to discover, fingerprint and test IPsec VPN servers";
    longDescription = ''
      ike-scan is a command-line tool that uses the IKE protocol to discover,
      fingerprint and test IPsec VPN servers.
    '';
    homepage = "https://github.com/royhills/ike-scan";
    license = with licenses; [ gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ fab ];
  };
}
