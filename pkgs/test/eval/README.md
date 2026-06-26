# Eval tests

This directory contains tests for Nixpkgs eval itself.
For example, you can test that a deprecated feature gives the expected result _and_ emits the expected warning.

The test harness itself is in `default.nix` and `test.py`, which reads all other `.nix` files in the directory and evaluates their tests.

A test file can accept `pkgs` and/or `lib` as inputs and should evaluate to an attrset of test attributes.
Each test attribute can define:

- `name` the assertion name printed in build logs (`string`: defaults to the attribute name)
- `expr` the nix expression under test (any)
- `stdout` the stdout expected from `nix-instantiate` (`string`: defaults to `"true\n"`)
- `stderr` the stderr expected from `nix-instantiate` (`string`: optional)
- `exit` the exit code expected from `nix-instantiate` (`int`: defaults to `0`)
- `test` a function for custom assertions (`({ stdoutFile :: String, stderrFile :: String, exit :: Integer } → Any)`: optional, can throw)

For example:
```nix
{ pkgs, lib }:
{
  example-test = {
    name = "Example";
    expr = lib.warn "foo" true;
    stderr = ''
      evaluation warning: foo
    '';
  };
}
```
