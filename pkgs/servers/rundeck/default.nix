{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "rundeck-${version}";
  version = "2.6.2";

  src = fetchurl {
    url = "http://dl.bintray.com/rundeck/rundeck-maven/rundeck-launcher-${version}.jar";
    sha256 = "1vcj00zwkjqk62b7ikm538s5y08w7y68l0czx8pa2yv0v9s3wx42";
  };
  meta = with stdenv.lib; {
    description = "Job scheduler and runbook automation";
    homepage = http://rundeck.org;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ ];
  };

  buildCommand = "ln -s $src $out";
}

