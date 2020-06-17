{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "lnch";
  version = "2017-02-16";

  goPackagePath = "github.com/oem/${pname}";

  src = fetchFromGitHub {
    owner = "oem";
    repo = pname;
    rev = "f24eed5392f01d2c8a9cfe9cdf70dcfbbf4b6b36";
    sha256 = "0skzrjnbxq1yj7y64cq7angp4wqnrgw1xp9v8vw9zp8f8zwmpy0y";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/oem/lnch";
    description = "A small go app that launches a process and moves it out of the process group";
    platforms = platforms.all;
    license = licenses.publicDomain; # really I don't know
  };
}
