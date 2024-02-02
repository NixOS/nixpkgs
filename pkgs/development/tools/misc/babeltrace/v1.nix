{ callPackage
, libuuid
, popt
}:

callPackage ./common.nix
{
  version = "1.5.11";
  hash = "sha256-kreCyByYgWhEhRXulVithOweVhadat3ZmsbbbcUYKN8=";
}
{
  pname = "babeltrace";

  buildInputs = [ libuuid popt ];
}
