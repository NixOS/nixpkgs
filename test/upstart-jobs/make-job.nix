{stdenv}: job:

stdenv.mkDerivation {
  inherit (job) name job;
  builder = builtins.toFile "builder.sh"
    "source $stdenv/setup; ensureDir $out/etc/event.d; echo \"$job\" > $out/etc/event.d/$name";
}
