{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "cde-0.1";
  src = fetchgit {
    url = "https://github.com/pgbovine/CDE.git";
    sha256 = "";
    rev = "551e54d95eb3f8eefc698891f1b873fc4f02f360";
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
    homepage = "https://github.com/pgbovine/CDE";
    description = "A packaging tool for building portable packages";
    license = licenses.gpl3;
    maintainers = [ maintainers.rlupton20 ];
    platforms = platforms.linux;
  };
}
