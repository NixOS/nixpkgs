{ stdenv, rustPlatform, fetchFromGitHub, ncurses }:

rustPlatform.buildRustPackage rec {
  name = "skim-v${version}";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "lotabout";
    repo = "skim";
    rev = "v${version}";
    sha256 = "1dvvrjvryzffqxqpg10ahg7rx9wkkav1q413bza3x3afb0jlsx15";
  };

  cargoSha256 = "0zf3y74382m4347yn1sygzd3g9b6vn5dmckj5nyll20azc6shyvc";

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    description = "Fuzzy Finder in rust";
    homepage = https://github.com/lotabout/skim;
    license = licenses.mit;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
