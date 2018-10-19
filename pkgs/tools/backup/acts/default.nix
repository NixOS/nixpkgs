{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "acts";
  version = "1.3";

  src = fetchFromGitHub {
    owner   = "alexjurkiewicz";
    repo    = "acts";
    rev     = version;
    sha256  = "1gmhnksbmbn0icp7vqvzkh4i5hbar0k1l144j48rrsw8035sin6a";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/{bin,etc}

    mv acts $out/bin
    mv acts.conf.sample $out/etc
  '';

  meta = with stdenv.lib; {
    description = "Another Calendar-based Tarsnap Script";
    homepage = "https://github.com/alexjurkiewicz/acts";
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = [ maintainers.asymmetric ];
  };
}
