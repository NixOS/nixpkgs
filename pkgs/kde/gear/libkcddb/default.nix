{
  mkKdeDerivation,
  libmusicbrainz,
}:
mkKdeDerivation {
  pname = "libkcddb";

  extraBuildInputs = [ libmusicbrainz ];
}
