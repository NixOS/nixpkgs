{ stdenv, fetchFromGitHub, fetchpatch, rustPlatform, openssl_1_0_2, cmake, perl, pkgconfig, zlib }:

with rustPlatform;

buildRustPackage rec {
  version = "0.9.1";
  pname = "git-series";

  src = fetchFromGitHub {
    owner = "git-series";
    repo = "git-series";
    rev = version;
    sha256 = "07mgq5h6r1gf3jflbv2khcz32bdazw7z1s8xcsafdarnm13ps014";
  };

  cargoSha256 = "07b25pcndhwvpwa5khdh8y1fl44hdv6ff2pfj1mjc0wchbspqm6q";

  cargoDepsHook = ''
    (
      cd */
      # see https://github.com/git-series/git-series/pull/56
      patch -p1 < ${fetchpatch {
        url = "https://github.com/Mic92/git-series/commit/3aa30a47d74ebf90b444dccdf8c153f07f119483.patch";
        sha256 = "06v8br9skvy75kcw2zgbswxyk82sqzc8smkbqpzmivxlc2i9rnh0";
      }}
    )
  '';

  nativeBuildInputs = [ cmake pkgconfig perl ];
  buildInputs = [ openssl_1_0_2 zlib ];

  postBuild = ''
    install -D "$src/git-series.1" "$out/man/man1/git-series.1"
  '';

  meta = with stdenv.lib; {
    description = "A tool to help with formatting git patches for review on mailing lists";
    longDescription = ''
          git series tracks changes to a patch series over time. git
          series also tracks a cover letter for the patch series,
          formats the series for email, and prepares pull requests.
    '';
    homepage = https://github.com/git-series/git-series;

    license = licenses.mit;
    maintainers = [ maintainers.vmandela ];
  };
}
