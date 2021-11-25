{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "oksh";
  version = "7.0";

  src = fetchFromGitHub {
    owner = "ibara";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-076nD0aPps6n5qkR3LQJ6Kn2g3mkov+/M0qSvxNLZ6o=";
  };

  meta = with lib; {
    description = "Portable OpenBSD ksh, based on the Public Domain Korn Shell (pdksh)";
    homepage = "https://github.com/ibara/oksh";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.all;
  };

  passthru = {
    shellPath = "/bin/oksh";
  };
}
