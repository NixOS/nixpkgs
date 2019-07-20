{ stdenv, fetchFromGitHub, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "hyperfine";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "0rwmigdnw2zgixzmif3wzw1adlyyk71jzvjfccqmgz840jkpvmcy";
  };

  cargoSha256 = "1j9ngbabg6vchgpiaqsbcvsm86syx2nbckzf9a4b29m69jv4pp1y";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Command-line benchmarking tool";
    homepage    = https://github.com/sharkdp/hyperfine;
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.thoughtpolice ];
    platforms   = platforms.all;
  };
}
