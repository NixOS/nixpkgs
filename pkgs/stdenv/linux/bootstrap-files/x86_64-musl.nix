{
  busybox = import <nix/fetchurl.nix> {
    url = https://wdtz.org/files/030q34q7fk6jdfxkgcqp5rzr4yhw3pgx-stdenv-bootstrap-tools-x86_64-unknown-linux-musl/on-server/busybox;
    sha256 = "16lzrwwvdk6q3g08gs45pldz0rh6xpln2343xr444960h6wqxl5v";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = https://wdtz.org/files/030q34q7fk6jdfxkgcqp5rzr4yhw3pgx-stdenv-bootstrap-tools-x86_64-unknown-linux-musl/on-server/bootstrap-tools.tar.xz;
    sha256 = "0ly0wj8wzbikn2j8sn727vikk90bq36drh98qvfx1kkh5k5azm2j";
  };
}
