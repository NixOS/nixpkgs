{
  busybox = import <nix/fetchurl.nix> {
    url = https://wdtz.org/files/030q34q7fk6jdfxkgcqp5rzr4yhw3pgx-stdenv-bootstrap-tools-x86_64-unknown-linux-musl/on-server/busybox;
    sha256 = "16lzrwwvdk6q3g08gs45pldz0rh6xpln2343xr444960h6wqxl5v";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = https://wdtz.org/files/2m15z3pmg495w52jc8dg2nbxxzmzvb04-stdenv-bootstrap-tools/on-server/bootstrap-tools.tar.xz;
    sha256 = "1w66l0ra0sfy83hs80w6l0lb015hrhdg3xd89xh4c5kr8bcrjriw";
  };
}
