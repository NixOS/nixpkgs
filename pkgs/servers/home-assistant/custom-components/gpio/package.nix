{
  lib,
  buildHomeAssistantComponent,
  fetchFromCodeberg,
  gpiod,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "raboof";
  domain = "gpio";
  version = "0.0.4";

  src = fetchFromCodeberg {
    owner = "raboof";
    repo = "ha-gpio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JyyJPI0lbZLJj+016WgS1KXU5rnxUmRMafel4/wKsYk=";
  };

  dependencies = [ gpiod ];

  meta = {
    description = "Home Assistant GPIO custom integration";
    homepage = "https://codeberg.org/raboof/ha-gpio";
    maintainers = with lib.maintainers; [ raboof ];
    license = lib.licenses.asl20;
  };
})
