{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomplate";
  version = "3.6.0";

  # Git revision as defined here:
  # https://github.com/hairyhenderson/gomplate/blob/eb2dbf65167e8bef7b62615c30431d75adc4e4b6/Makefile#L13
  rev = "564f5588";

  src = fetchFromGitHub {
    owner = "hairyhenderson";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b936fa92v4p50xmbi53y11a7s02bhzn6n7svy5vbbpryrfnjmf9";
  };

  preBuild = ''
    export buildFlagsArray+=(
      "-ldflags=
        -w -s
        -X ${goPackagePath}/v3/version.Version=${version}
        -X ${goPackagePath}/v3/version.GitCommit=${rev}")
  '';

  goPackagePath = "github.com/hairyhenderson/gomplate";
  modSha256 = "1jg9xzbpi8b4jpg234gqnfsbf43jlngsrj3f1iz80niv8gnlidfy";

  meta = with stdenv.lib; {
    description = "A flexible commandline tool for template rendering. Supports lots of local and remote datasources";
    homepage = "https://gomplate.ca/";
    license = licenses.mit;
    maintainers = with maintainers; [ jlesquembre ];
    platforms = platforms.all;
  };
}
