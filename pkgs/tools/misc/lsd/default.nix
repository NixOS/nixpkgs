{ stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "lsd";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "Peltoche";
    repo = pname;
    rev = version;
    sha256 = "006fy87jrb77cpa6bywchcvq1p74vlpy151q1j4nsj8npbr02krj";
  };

  cargoSha256 = "0mrvcca9y0vylcrbfxxba45v05qxd8z91vb4in88px60xah0dy3q";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion $releaseDir/build/lsd-*/out/{_lsd,lsd.{bash,fish}}
  '';

  checkFlags = stdenv.lib.optionals stdenv.isDarwin [
    "--skip meta::filetype::test::test_socket_type"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/Peltoche/lsd";
    description = "The next gen ls command";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 marsam zowoq ];
  };
}
