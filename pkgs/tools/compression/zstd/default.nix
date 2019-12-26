{ stdenv, fetchFromGitHub, fetchpatch, gnugrep
, fixDarwinDylibNames
, file
, legacySupport ? false }:

stdenv.mkDerivation rec {
  pname = "zstd";
  version = "1.4.4";

  src = fetchFromGitHub {
    sha256 = "0zn7r8d4m8w2lblnjalqpz18na0spzkdiw3fwq2fzb7drhb32v54";
    rev = "v${version}";
    repo = "zstd";
    owner = "facebook";
  };

  patches = [
    # All 3 from https://github.com/facebook/zstd/pull/1883
    (fetchpatch {
      url = "https://github.com/facebook/zstd/commit/106278e7e5fafaea3b7deb4147bdc8071562d2f0.diff";
      sha256 = "13z7id1qbc05cv1rmak7c8xrchp7jh1i623bq5pwcihg57wzcyr8";
    })
    (fetchpatch {
      url = "https://github.com/facebook/zstd/commit/0ede342acc2c26f87ae962fa88e158904d4198c4.diff";
      sha256 = "12l5xbvnzkvr76mvl1ls767paqfwbd9q1pzq44ckacfpz4f6iaap";
      excludes = [
        # I think line endings are causing problems, or something like that
        "programs/windres/generate_res.bat"
      ];
    })
    (fetchpatch {
      url = "https://github.com/facebook/zstd/commit/10552eaffef84c011f67af0e04f0780b50a5ab26.diff";
      sha256 = "1s27ravar3rn7q8abybp9733jhpsfcaci51k04da94ahahvxwiqw";
    })
  ] # This I didn't upstream because if you use posix threads with MinGW it will
    # work find, and I'm not sure how to write the condition.
    ++ stdenv.lib.optional stdenv.hostPlatform.isWindows ./mcfgthreads-no-pthread.patch;

  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  makeFlags = [
    "ZSTD_LEGACY_SUPPORT=${if legacySupport then "1" else "0"}"
  ] ++ stdenv.lib.optional stdenv.hostPlatform.isWindows "OS=Windows";

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

    platforms = platforms.all;
    maintainers = with maintainers; [ orivej ];
  };
}
