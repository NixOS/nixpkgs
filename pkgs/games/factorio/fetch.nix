{ stdenv, curl, xidel, cacert
# Begin download parameters
, username ? ""
, password ? ""
}:

{
  # URL to fetch.
  url ? ""

, name ? "factorio.tar.gz"

  # Login URL.
, loginUrl ? "https://www.factorio.com/login"

  # SHA256 of the fetched URL.
, sha256 ? ""
}:

stdenv.mkDerivation {
  buildInputs = [ curl xidel ];

  inherit name url loginUrl username password cacert;

  builder = ./fetch.sh;

  outputHashAlgo = "sha256";
  outputHash = sha256;
  outputHashMode = "flat";

  # There's no point in downloading remotely, we'd just slow things down.
  preferLocalBuild = true;
}
