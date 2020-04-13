{ stdenv
, buildGoPackage
, fetchFromGitHub
}:

with builtins;

buildGoPackage rec {
  pname = "safe";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "starkandwayne";
    repo = "safe";
    rev = "v${version}";
    sha256 = "12gzxrnyl890h79z9yx23m1wwgy8ahm74q4qwi8n2nh7ydq6mn2d";
  };

  goPackagePath = "github.com/starkandwayne/safe";

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X main.Version=${version}")
  '';

  meta = with stdenv.lib; {
    description = "A Vault CLI";
    homepage = "https://github.com/starkandwayne/safe";
    license = licenses.mit;
    maintainers = with maintainers; [ eonpatapon ];
  };
}
