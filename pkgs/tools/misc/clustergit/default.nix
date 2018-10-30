{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "clustergit-${version}";
  version = "2018-04-18";

  src = fetchFromGitHub {
    owner = "mnagel";
    repo = "clustergit";
    rev = "0d94db95f965c0149eb8423eee991c4d18cf2d59";
    sha256 = "10v5zq5m1mpzr1xr8y7dkxw654wl9r0hp7n64g4nbjx2ay26yyy4";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -R ./clustergit $out/bin/clustergit
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/mnagel/clustergit;
    description = "Tool for running Git commands on multiple repositories at once";
    license = licenses.publicDomain;
    maintainers = [ maintainers.gmarmstrong ];
    platforms = platforms.unix;
  };
}
