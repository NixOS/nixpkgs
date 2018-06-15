{ stdenv, fetchFromGitHub, cmake, zlib, openssl }:

stdenv.mkDerivation rec {
  name = "unshield-${version}";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "twogood";
    repo = "unshield";
    rev = version;
    sha256 = "07lmh8vmrbqy4kd6zl5yc1ar3bg33w5cymlzwfijy6arg77hjgq9";
  };


  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib openssl ];

  meta = with stdenv.lib; {
    description = "Tool and library to extract CAB files from InstallShield installers";
    homepage = https://github.com/twogood/unshield;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
