{ stdenv, fetchFromGitHub, rustPlatform, installShellFiles
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "hyperfine";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "0389lmyipmm4irrl39zw2748f2sdddfzwms4i4763xdykdvi8b57";
  };

  cargoSha256 = "06scvp7x1yixdadarsm461hbc256spx4aqhmjjn72x7hxn22h9cg";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  postInstall = ''
    installManPage doc/hyperfine.1

    installShellCompletion \
      $releaseDir/build/hyperfine-*/out/hyperfine.{bash,fish} \
      --zsh $releaseDir/build/hyperfine-*/out/_hyperfine
  '';

  meta = with stdenv.lib; {
    description = "Command-line benchmarking tool";
    homepage    = "https://github.com/sharkdp/hyperfine";
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.thoughtpolice ];
    platforms   = platforms.all;
  };
}
