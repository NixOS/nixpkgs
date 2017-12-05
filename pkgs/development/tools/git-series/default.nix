{ stdenv, fetchFromGitHub, rustPlatform, openssl, cmake, perl, pkgconfig, zlib }:

with rustPlatform;

buildRustPackage rec {
  version = "0.9.1";
  name = "git-series-${version}";

  src = fetchFromGitHub {
    owner = "git-series";
    repo = "git-series";
    rev = version;
    sha256 = "07mgq5h6r1gf3jflbv2khcz32bdazw7z1s8xcsafdarnm13ps014";
  };

  depsSha256 = "1xypk9ck7znca0nqm61m5ngpz6q7c0wydlpwxq4mnkd1np27xn53";

  nativeBuildInputs = [ cmake pkgconfig perl ];
  buildInputs = [ openssl zlib ];

  postBuild = ''
    mkdir -p "$out/man/man1"
    cp "$src/git-series.1" "$out/man/man1"
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
