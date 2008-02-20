args: with args;

stdenv.mkDerivation rec {
  name = "wget-" + version;
  src = fetchurl {
    url = "mirror://gnu/wget/${name}.tar.bz2";
    sha256 = "0mhd3181zdp1fwirxw0km7502sfvjmm1ncska9w6s2drczf37aix";
  };

  buildInputs = [gettext];

  meta = {
    description = "A console downloading program. Has some features for mirroring sites.";
    homepage = http://www.gnu.org/software/wget;
  };
}
