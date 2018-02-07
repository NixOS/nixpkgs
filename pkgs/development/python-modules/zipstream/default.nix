{ lib, buildPythonPackage, fetchurl, nose }:

let
  pname = "zipstream";
  version = "1.1.4";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/z/${pname}/${name}.tar.gz";
    sha256 = "01im5anqdyggmwkigqcjg0qw2a5bnn84h33mfaqjjd69a28lpwif";
  };

  buildInputs = [ nose ];

  meta = {
    description = "A zip archive generator";
    homepage = https://github.com/allanlei/python-zipstream;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ primeos ];
  };
}
