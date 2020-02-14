{ stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "mcfly";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "cantino";
    repo = "mcfly";
    rev = "v${version}";
    sha256 = "1g3n7ll0yg7w7hb3jgp25mlnqwsdzv0608f41z7q5gmsskdm3v1j";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  preInstall = ''
    install -Dm644 -t $out/share/mcfly mcfly.bash
  '';

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "1bf65kagvhsi6lg8187ihi5j45hkq9d8v6j7rzmmfhngdzvcfr69";

  meta = with stdenv.lib; {
    homepage = https://github.com/cantino/mcfly;
    description = "An upgraded ctrl-r for Bash whose history results make sense for what you're working on right now.";
    license = licenses.mit;
    maintainers = [ maintainers.melkor333 ];
  };
}
