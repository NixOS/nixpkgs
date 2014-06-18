{ stdenv, fetchgit, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "s3cmd-1.5-pre-81e3842f7a";

  src  = fetchgit {
    url    = "https://github.com/s3tools/s3cmd.git";
    rev    = "81e3842f7afbc8c629f408f4d7dc22058f7bd536";
    sha256 = "13jqw19ws5my8r856j1p7xydwpyp8agnzxkjv6pa7h72wl7rz90i";
  };

  propagatedBuildInputs = with pythonPackages; [ dateutil ];

  meta = with stdenv.lib;  {
    description = "Command line tool for managing Amazon S3 and CloudFront services";
    homepage    = http://s3tools.org/s3cmd;
    license     = licenses.gpl2;
  };
}
