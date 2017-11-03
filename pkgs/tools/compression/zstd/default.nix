{ stdenv, fetchFromGitHub, gnugrep
, legacySupport ? false }:

stdenv.mkDerivation rec {
  name = "zstd-${version}";
  version = "1.3.0";

  src = fetchFromGitHub {
    sha256 = "1rnxfhcmg8zsagyf70hiwm32mam60hq58pzgy7jn8c3iwv24mpz5";
    rev = "v${version}";
    repo = "zstd";
    owner = "facebook";
  };

  makeFlags = [
    "ZSTD_LEGACY_SUPPORT=${if legacySupport then "1" else "0"}"
  ];

  installFlags = [
    "PREFIX=$(out)"
  ];

  preInstall = ''
    substituteInPlace programs/zstdgrep \
      --replace "=grep" "=${gnugrep}/bin/grep" \
      --replace "=zstdcat" "=$out/bin/zstdcat"

    substituteInPlace programs/zstdless \
      --replace "zstdcat" "$out/bin/zstdcat"
  '';

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

    platforms = platforms.unix;
    maintainers = with maintainers; [ nckx orivej ];
  };
}
