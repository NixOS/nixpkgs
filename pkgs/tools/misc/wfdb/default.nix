{ stdenv, fetchurl, gnutar, gzip, gnumake, coreutils, gawk, gnused, gnugrep, bash, clang, which}:
stdenv.mkDerivation {
  name = "wfdb";
  builder = "${bash}/bin/bash";
  args = [ ./builder.sh ];
  gcc = clang;
  binutils = clang.bintools.bintools_bin;
  buildInputs = [ gnutar gzip gnumake coreutils gawk gnused gnugrep which clang clang.bintools.bintools_bin ];
  src = fetchurl{
        url = https://archive.physionet.org/physiotools/wfdb.tar.gz;
        sha256 = "6a76da12746a51bfcd1a87461c9578b6eef741933c83d7a5e5b16f605b44afdc";
  };
  system = builtins.currentSystem;
}