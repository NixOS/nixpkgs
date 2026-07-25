{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "statsd";
  version = "0"; # repo down

  src = fetchFromGitHub {
    owner = "harvesthq";
    repo = "nginx-statsd";
    rev = "b970e40467a624ba710c9a5106879a0554413d15";
    sha256 = "1x8j4i1i2ahrr7qvz03vkldgdjdxi6mx75mzkfizfcc8smr4salr";
  };

  meta = {
    description = "Send statistics to statsd";
    homepage = "https://github.com/harvesthq/nginx-statsd";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
