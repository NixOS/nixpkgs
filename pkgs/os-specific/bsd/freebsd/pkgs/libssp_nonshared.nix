{
  mkDerivation,
  include,
}:

mkDerivation {
  path = "lib/libssp_nonshared";
  noLibc = true;

  buildInputs = [
    include
  ];

  alwaysKeepStatic = true;
}
