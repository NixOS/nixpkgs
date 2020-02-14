{ stdenv, fetchFromGitHub, rustPlatform
, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vkp6yfafzyhilkk5rfvgka91gmhm9nrrvy3m6gdza4ayslmcpam";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  postPatch = ''
    substituteInPlace src/utils.rs \
      --replace "/bin/echo" "echo"
  '';

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "05q527bd5q6a7kd03hwic4bynyc4sipyvi0bf2g2jqxzcsmswyyk";
  checkPhase = "cargo test -- --skip directory::home_directory --skip directory::directory_in_root";

  meta = with stdenv.lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras davidtwco filalex77 ];
    platforms = platforms.all;
  };
}
