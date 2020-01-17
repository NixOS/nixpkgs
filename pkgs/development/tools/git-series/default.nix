{ stdenv, fetchFromGitHub, fetchpatch, rustPlatform
, openssl, cmake, perl, pkgconfig, zlib, curl, libgit2, libssh2
}:

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

  cargoSha256 = "16qjbvppc01yxk8x9jk7gs8jaag5nkfl30j3lyv3dc27vv9mckjv";

  cargoPatches = [
    (fetchpatch {
      url = "https://github.com/Mic92/git-series/commit/3aa30a47d74ebf90b444dccdf8c153f07f119483.patch";
      sha256 = "06v8br9skvy75kcw2zgbswxyk82sqzc8smkbqpzmivxlc2i9rnh0";
    })
    # Update Cargo.lock to allow using OpenSSL 1.1
    (fetchpatch {
      url = "https://github.com/edef1c/git-series/commit/11fe70ffcc18200e5f2a159c36aab070e8ff4228.patch";
      sha256 = "0clwllf9mrhq86dhzyyhkw1q2ggpgqpw7s05dvp3gj9zhfsyya4s";
    })
    # Cargo.lock: Update url, which fixes incompatibility with NLL
    (fetchpatch {
      url = "https://github.com/edef1c/git-series/commit/27ff2ecf2d615dae1113709eca0e43596de12ac4.patch";
      sha256 = "1byjbdcx56nd0bbwz078bl340rk334mb34cvaa58h76byvhpkw10";
    })
  ];

  LIBGIT2_SYS_USE_PKG_CONFIG = true;
  LIBSSH2_SYS_USE_PKG_CONFIG = true;
  nativeBuildInputs = [ cmake pkgconfig perl ];
  buildInputs = [ openssl zlib curl libgit2 libssh2 ];

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
    maintainers = with maintainers; [ edef vmandela ];
  };
}
