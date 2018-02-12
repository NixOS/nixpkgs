# Use busybox for i686-linux since it works on x86_64-linux as well.
(import ./i686.nix) //

{
  bootstrapTools = import <nix/fetchurl.nix> {
    url = https://wdtz.org/files/030q34q7fk6jdfxkgcqp5rzr4yhw3pgx-stdenv-bootstrap-tools-x86_64-unknown-linux-musl/on-server/bootstrap-tools.tar.xz;
    sha256 = "0ly0wj8wzbikn2j8sn727vikk90bq36drh98qvfx1kkh5k5azm2j";
  };
}
