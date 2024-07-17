{
  mkDerivation,
  compatIfNeeded,
  libjail,
}:
mkDerivation {
  path = "sbin/route";
  buildInputs = compatIfNeeded ++ [ libjail ];
  MK_TESTS = "no";
}
