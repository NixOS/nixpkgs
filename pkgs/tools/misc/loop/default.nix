{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  name = "loop-unstable-2018-12-04";

  src = fetchFromGitHub {
    owner = "Miserlou";
    repo  = "Loop";
    rev   = "598ccc8e52bb13b8aff78b61cfe5b10ff576cecf";
    sha256 = "0f33sc1slg97q1aisdrb465c3p7fgdh2swv8k3yphpnja37f5nl4";
  };

  cargoSha256 = "1ydd0sd4lvl6fdl4b13ncqcs03sbxb6v9dwfyqi64zihqzpblshv";

  meta = with stdenv.lib; {
    description = "UNIX's missing `loop` command";
    homepage = https://github.com/Miserlou/Loop;
    maintainers = with maintainers; [ koral ];
    license = licenses.mit;
  };
}
