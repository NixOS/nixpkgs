{ lib, rustPlatform, fetchFromGitHub
, pkg-config, openssl, zlib, curl, libgit2, libssh2
}:

rustPlatform.buildRustPackage rec {
  pname = "git-series";
  version = "unstable-2019-10-15";

  src = fetchFromGitHub {
    owner = "git-series";
    repo = "git-series";
    rev = "c570a015e15214be46a7fd06ba08526622738e20";
    sha256 = "1i0m2b7ma6xvkg95k57gaj1wpc1rfvka6h8jr5hglxmqqbz6cb6w";
  };

  cargoSha256 = "1hmx14z3098c98achgii0jkcm4474iw762rmib77amcsxj73zzdh";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl zlib curl libgit2 libssh2 ];

  LIBGIT2_SYS_USE_PKG_CONFIG = true;
  LIBSSH2_SYS_USE_PKG_CONFIG = true;

  postInstall = ''
    install -D "$src/git-series.1" "$out/man/man1/git-series.1"
  '';

  meta = with lib; {
    description = "A tool to help with formatting git patches for review on mailing lists";
    longDescription = ''
      git series tracks changes to a patch series over time. git
      series also tracks a cover letter for the patch series,
      formats the series for email, and prepares pull requests.
    '';
    homepage = "https://github.com/git-series/git-series";

    license = licenses.mit;
    maintainers = with maintainers; [ edef vmandela ];
  };
}
