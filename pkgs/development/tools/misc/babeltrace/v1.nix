{ callPackage
, libuuid
, popt
}:

callPackage ./common.nix
{
  version = "1.5.8";
  hash = "sha256-n3ov/MfxG0oVZQAwo1KlnZctfTdODkxelRUcD4C02qw=";
}
{
  pname = "babeltrace";

  buildInputs = [ libuuid popt ];
}
