{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "povray-3.6";

  src = fetchurl {
    url = http://www.povray.org/redirect/www.povray.org/ftp/pub/povray/Official/Unix/povray-3.6.tar.bz2;
    sha256 = "0wvsfgkybx28mj2p76nnsq9rdq50192g5qb7d0xk81s8skn7z2jf";
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
