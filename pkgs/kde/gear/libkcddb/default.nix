{
  mkKdeDerivation,
  libmusicbrainz5,
}:
mkKdeDerivation {
  pname = "libkcddb";

  extraBuildInputs = [libmusicbrainz5];
}
