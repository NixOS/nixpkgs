{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "cde-${version}";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "pgbovine";
    repo = "CDE";
    sha256 = "0raiz7pczkbnzxpg7g59v7gdp1ipkwgms2vh3431snw1va1gjzmk";
    rev = "v${version}";
  };

  # The build is small, so there should be no problem
  # running this locally. There is also a use case for
  # older systems, where modern binaries might not be
  # useful.
  preferLocalBuild = true;

  patchBuild = ''
    sed '/install/d' $src/Makefile > $src/Makefile
  '';
  
  installPhase = ''
    mkdir -p $out/bin
    cp cde $out/bin
    cp cde-exec $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pgbovine/CDE;
    description = "A packaging tool for building portable packages";
    license = licenses.gpl3;
    maintainers = [ maintainers.rlupton20 ];
    platforms = platforms.linux;
  };
}
