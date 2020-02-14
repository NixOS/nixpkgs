{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  name = "loop-unstable-2018-12-04";

  src = fetchFromGitHub {
    owner = "Miserlou";
    repo  = "Loop";
    rev   = "598ccc8e52bb13b8aff78b61cfe5b10ff576cecf";
    sha256 = "0f33sc1slg97q1aisdrb465c3p7fgdh2swv8k3yphpnja37f5nl4";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "19x8n39yaa924naldw6fv7mq9qb500arkhwj9jz2fsbhz5nz607r";

  meta = with stdenv.lib; {
    description = "UNIX's missing `loop` command";
    homepage = https://github.com/Miserlou/Loop;
    maintainers = with maintainers; [ koral ];
    license = licenses.mit;
  };
}
