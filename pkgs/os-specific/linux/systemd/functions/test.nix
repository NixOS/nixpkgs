{
  lib,
  systemd,
  ok,
}:

# This function is also tested in nixosTests.systemd-escaping
assert systemd.functions.escapeSystemdExecArg "hi" == ''"hi"'';
assert systemd.functions.escapeSystemdExecArg "hi there" == ''"hi there"'';
assert systemd.functions.escapeSystemdExecArg ''"hi there"'' == ''"\"hi there\""'';
assert systemd.functions.escapeSystemdExecArg ''"%$'' == ''"\"%%$$"'';
assert
  systemd.functions.escapeSystemdExecArgs [
    "hi"
    "there"
  ] == ''"hi" "there"'';
assert
  systemd.functions.escapeSystemdExecArgs [
    "hi"
    "%"
    "there"
  ] == ''"hi" "%%" "there"'';
ok
