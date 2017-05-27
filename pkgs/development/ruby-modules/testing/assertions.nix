{ test, lib, ...}:
{
  equal = expected: actual:
    if actual == expected then
      (test.passed "= ${toString expected}") else
      (test.failed "'${toString actual}'(${builtins.typeOf actual}) != '${toString expected}'(${builtins.typeOf expected})");

  beASet = actual:
    if builtins.isAttrs actual then
      (test.passed "is a set") else
      (test.failed "is not a set, was ${builtins.typeOf actual}: ${toString actual}");

  haveKeys = expected: actual:
    if builtins.all
    (ex: builtins.any (ac: ex == ac) (builtins.attrNames actual))
    expected then
      (test.passed "has expected keys") else
      (test.failed "keys differ: expected [${lib.concatStringsSep ";" expected}] have [${lib.concatStringsSep ";" (builtins.attrNames actual)}]");

  havePrefix = expected: actual:
    if lib.hasPrefix expected actual then
      (test.passed "has prefix '${expected}'") else
      (test.failed "prefix '${expected}' not found in '${actual}'");
}
