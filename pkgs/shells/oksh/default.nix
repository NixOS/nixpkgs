{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "oksh";
  version = "6.9";

  src = fetchFromGitHub {
    owner = "ibara";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-b5b6xYqlmjWAT8kTq6YraVLawV/k3ugHZUjXD1LJyhs=";
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
