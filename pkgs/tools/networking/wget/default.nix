{stdenv, fetchurl, gettext}:

stdenv.mkDerivation {
  name = "wget-1.10.2";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/wget/wget-1.10.2.tar.gz;
    md5 = "795fefbb7099f93e2d346b026785c4b8";
  };

  buildInputs = [gettext];
}
