{ stdenv, fetchFromGitHub, gnugrep
, fixDarwinDylibNames
, file
, legacySupport ? false }:

stdenv.mkDerivation rec {
  pname = "zstd";
  version = "1.4.3";

  src = fetchFromGitHub {
    sha256 = "0mmgs98cfh92gcbjyv37vz8nq7x4x7fbzymlxyqd9awwpv9v0i5n";
    rev = "v${version}";
    repo = "zstd";
    owner = "facebook";
  };

  buildInputs = stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  makeFlags = [
    "ZSTD_LEGACY_SUPPORT=${if legacySupport then "1" else "0"}"
  ];

  checkInputs = [ file ];
  doCheck = true;
  preCheck = ''
    substituteInPlace tests/playTests.sh \
      --replace 'MD5SUM="md5 -r"' 'MD5SUM="md5sum"'
  '';

  installFlags = [
    "PREFIX=$(out)"
  ];

  preInstall = ''
    substituteInPlace programs/zstdgrep \
      --replace ":-grep" ":-${gnugrep}/bin/grep" \
      --replace ":-zstdcat" ":-$out/bin/zstdcat"

    substituteInPlace programs/zstdless \
      --replace "zstdcat" "$out/bin/zstdcat"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Zstandard real-time compression algorithm";
    longDescription = ''
      Zstd, short for Zstandard, is a fast lossless compression algorithm,
      targeting real-time compression scenarios at zlib-level compression
      ratio. Zstd can also offer stronger compression ratio at the cost of
      compression speed. Speed/ratio trade-off is configurable by small
      increment, to fit different situations. Note however that decompression
      speed is preserved and remain roughly the same at all settings, a
      property shared by most LZ compression algorithms, such as zlib.
    '';
    homepage = https://facebook.github.io/zstd/;
    license = with licenses; [ bsd3 ]; # Or, at your opinion, GPL-2.0-only.

    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
