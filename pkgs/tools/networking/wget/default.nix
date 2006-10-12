{stdenv, fetchurl, gettext}:

stdenv.mkDerivation {
  name = "wget-1.10.2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/wget-1.10.2.tar.gz;
    md5 = "795fefbb7099f93e2d346b026785c4b8";
  };

  buildInputs = [gettext];
}
