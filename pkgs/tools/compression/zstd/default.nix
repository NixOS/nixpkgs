{ stdenv, fetchFromGitHub
, legacySupport ? false }:

stdenv.mkDerivation rec {
  name = "zstd-${version}";
  version = "0.5.1";

  src = fetchFromGitHub {
    sha256 = "18mfrq5fqd7gkkqrgc32rlb98vw45rq1vsbrg44bprg3mv6ca3ls";
    rev = "v${version}";
    repo = "zstd";
    owner = "Cyan4973";
  };

  # The Makefiles don't properly use file targets, but blindly rebuild
  # all dependencies on every make invocation. So no nice phases. :-(
  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  makeFlags = [
    "ZSTD_LEGACY_SUPPORT=${if legacySupport then "1" else "0"}"
  ];

  installFlags = [
    "PREFIX=$(out)"
  ];

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
    homepage = http://www.zstd.net/;
    # The licence of the CLI programme is GPLv2+, that of the library BSD-2.
    license = with licenses; [ gpl2Plus bsd2 ];

    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
