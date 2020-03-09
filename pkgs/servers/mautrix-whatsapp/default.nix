{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "mautrix-whatsapp-unstable";
  version = "2020-02-09";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "260555b69ccd20f247405e4d8cab3d49fabda070";
    sha256 = "1ykhwrp8bvhzzw4lg4m1w430ybgzd0zqgrs4jrvfd1m0als2iff7";
  };

  modSha256 = "0ypj79rjwj5bls6aq2cz0d034dnv1sddl43iz51b4fl2bfv0drm9";

  meta = with stdenv.lib; {
    homepage = https://github.com/tulir/mautrix-whatsapp;
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
