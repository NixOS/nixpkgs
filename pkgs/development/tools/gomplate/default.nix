{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gomplate";
  version = "3.5.0";

  # Git revision as defined here:
  # https://github.com/hairyhenderson/gomplate/blob/eb2dbf65167e8bef7b62615c30431d75adc4e4b6/Makefile#L13
  rev = "fd00d0ff";

  src = fetchFromGitHub {
     owner = "hairyhenderson";
     repo = pname;
     rev = "v${version}";
     sha256 = "0q3fssgwn7p95pn4nh5qajssrc55jqf5gwq6cpirfim0c339pl95";
   };

  preBuild = ''
    export buildFlagsArray+=(
      "-ldflags=
        -w -s
        -X ${goPackagePath}/version.Version=${version}
        -X ${goPackagePath}/version.GitCommit=${rev}")
  '';

  goPackagePath = "github.com/hairyhenderson/gomplate";
  subPackages = [ "cmd/gomplate" ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A flexible commandline tool for template rendering. Supports lots of local and remote datasources";
    homepage = https://gomplate.ca/;
    license = licenses.mit;
    maintainers = with maintainers; [ jlesquembre ];
    platforms = platforms.all;
  };
}
