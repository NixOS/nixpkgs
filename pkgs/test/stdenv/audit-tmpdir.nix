{
  initialBash,
  initialPath,
  stdenv,
}:

(derivation {
  name = "test-audit-tmpdir";
  system = stdenv.system;
  builder = "${initialBash}/bin/bash";
  inherit initialPath;
  args = [
    "${./audit-tmpdir.sh}"
    "${../../stdenv/generic/setup.sh}"
    "${../../build-support/setup-hooks/audit-tmpdir.sh}"
    "${initialBash}/bin/bash"
  ];
})
// {
  meta = { };
}
