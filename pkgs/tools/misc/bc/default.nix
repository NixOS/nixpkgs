{stdenv, fetchurl, flex, readline, ed, texinfo}:

stdenv.mkDerivation rec {
  name = "bc-1.07.1";
  src = fetchurl {
    url = "mirror://gnu/bc/${name}.tar.gz";
    sha256 = "62adfca89b0a1c0164c2cdca59ca210c1d44c3ffc46daf9931cf4942664cb02a";
  };

  configureFlags = [ "--with-readline" ];

  buildInputs = [flex readline ed texinfo];

  doCheck = true;

  meta = {
    description = "GNU software calculator";
    homepage = http://www.gnu.org/software/bc/;
    platforms = stdenv.lib.platforms.all;
  };
}
