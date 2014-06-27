{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "povray-3.6";

  src = fetchurl {
    url = http://www.povray.org/ftp/pub/povray/Old-Versions/Official-3.62/Unix/povray-3.6.tar.bz2;
    sha256 = "4e8a7fecd44807343b6867e1f2440aa0e09613d6d69a7385ac48f4e5e7737a73";
  };

  # the installPhase wants to put files into $HOME. I let it put the files
  # to $TMPDIR, so they don't get into the $out
  patchPhase = ''
    sed -i -e 's/^povconfuser.*/povconfuser=$(TMPDIR)\/povray/' Makefile.{am,in};
  '';
  # I didn't use configureFlags because I couldn't pass the quotes properly
  # for the COMPILED_BY.
  configurePhase = "./configure --prefix=$out COMPILED_BY=\"nix\"";
  
  meta = {
    homepage = http://www.povray.org/;
    description = "Persistence of Vision Raytracer";
    license = "free";
  };
}
