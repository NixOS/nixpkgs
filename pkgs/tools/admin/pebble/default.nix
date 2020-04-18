{ buildGoPackage
, fetchFromGitHub
, lib
}:

let
  version = "v2.2.2";
  pname = "pebble";
in buildGoPackage {
  inherit pname version;
  goPackagePath = "github.com/letsencrypt/${pname}";

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = pname;
    rev = version;
    sha256 = "10g6ivdxxp3632wk0gvmp75v9x668kchhmlczbsq8qnsc8sb8pwf";
  };

  meta = {
    homepage = "https://github.com/letsencrypt/boulder";
    description = "A miniature version of Boulder, Pebble is a small RFC 8555 ACME test server not suited for a production CA";
    license = [ lib.licenses.mpl20 ];
    maintainers = [ ];
  };
}
