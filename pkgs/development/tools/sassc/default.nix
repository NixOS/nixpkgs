{ stdenv, fetchFromGitHub, autoreconfHook, libsass }:

stdenv.mkDerivation rec {
  pname = "sassc";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "sass";
    repo = pname;
    rev = version;
    sha256 = "14cbprnz70bv9qcs1aglvj9kkhf22as5xxz7gkv2ni8yjy8rp8q2";
  };

  patchPhase = ''
    export SASSC_VERSION=${version}
  '';

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libsass ];

  meta = with stdenv.lib; {
    description = "A front-end for libsass";
    homepage = https://github.com/sass/sassc/;
    license = licenses.mit;
    maintainers = with maintainers; [ codyopel pjones ];
    platforms = platforms.unix;
  };
}
